//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Maxim Tzvetkov on 15.04.25.
//

import XCTest
@testable import CurrencyConverter

class MockNetworkService: NetworkService {
    
    var mockResponse: Currency?
    var mockError: Error?
    
    func request<T>(baseURL: String, path: String, method: HTTPMethod) async throws -> T where T : Decodable {
        if let mockError {
            throw mockError
        }
        
        if let response = mockResponse as? T {
            return response
        }
        
        fatalError("Mock response wrong type")
    }
}

final class CurrencyConverterTests: XCTestCase {

    var mockService: MockNetworkService!
    var viewModel: CurrencyConverterViewModel!
    
    override func setUp() {
        mockService = MockNetworkService()
        mockService.mockResponse = loadMockCurrencies()
        
        viewModel = CurrencyConverterViewModel(network: mockService)
    }
    
    func testFetchRatesSuccess() async {
        await viewModel.fetchRates(for: "USD")
        XCTAssertTrue(viewModel.currenies.contains("EUR"))
        XCTAssertTrue(viewModel.currenies.contains("JPY"))
        XCTAssertTrue(viewModel.currenies.contains("BGN"))
    }

    func testConvertAmountSuccess() async {
        viewModel.amount = "2000"
        viewModel.sourceCurrency = "USD"
        viewModel.targetCurrency = "BGN"
        
        await viewModel.fetchRates(for: "USD")
        await viewModel.convertAmount()
        
        XCTAssertEqual(viewModel.convertedAmount, "3436.00")
    }
    
    func testSwapCurrencies() async {
        viewModel.sourceCurrency = "USD"
        viewModel.targetCurrency = "EUR"
        
        viewModel.swapCurrencies()
        
        XCTAssertEqual(viewModel.sourceCurrency, "EUR")
        XCTAssertEqual(viewModel.targetCurrency, "USD")
    }
    
    func testCurrencyNotSelected() async {
        viewModel.amount = "100"
        viewModel.sourceCurrency = nil
        viewModel.targetCurrency = "USD"
        
        await viewModel.convertAmount()
        
        XCTAssertEqual(viewModel.convertedAmount, "-")
    }
    
    func testConvertedAmountRounded() async {
        viewModel.amount = "1"
        viewModel.sourceCurrency = "USD"
        viewModel.targetCurrency = "JPY"
        
        await viewModel.fetchRates(for: "USD")
        await viewModel.convertAmount()
        
        XCTAssertEqual(viewModel.convertedAmount, "142.25")
        XCTAssertFalse(viewModel.convertedAmount.contains(".2528"))
    }
    
    private func loadMockCurrencies(fileName: String = "currency") -> Currency {
        let bundle = Bundle(for: CurrencyConverterTests.self)
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Missing file: \(fileName).json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Currency.self, from: data)
        } catch {
            fatalError("Failed to load or decode \(fileName).json: \(error)")
        }
    }
}
