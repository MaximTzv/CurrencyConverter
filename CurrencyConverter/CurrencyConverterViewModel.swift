//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Maxim Tzvetkov on 15.04.25.
//

import Foundation

struct Currency: Codable {
    
    let result: String
    let documentation: String
    let termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC, baseCode: String
    let conversionRates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result, documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}

class CurrencyConverterViewModel: ObservableObject {
    
    @Published var amount: String = ""
    @Published var convertedAmount: String = ""
    
    @Published var currenies: [String] = []
    @Published var errorMessage: String?
    
    @Published var sourceCurrency: String?
    @Published var targetCurrency: String?
    
    private var conversionRates: [String: Double] = [:]
    private let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func convertAmount() async {
        guard let to = targetCurrency,
                let amountValue = Double(amount),
                let rate = conversionRates[to] else {
                    await MainActor.run {
                        convertedAmount = "-"
                    }
                    return
                }
        
        let result = amountValue * rate
        
        await MainActor.run {
            convertedAmount = String(format: "%.2f", result)
        }
    }
    
    func swapCurrencies() {
        guard let from = sourceCurrency, let to = targetCurrency else { return }
        sourceCurrency = to
        targetCurrency = from
        
        Task {
            await fetchRates(for: to)
            await convertAmount()
        }
    }
    
    func fetchRates(for currency: String) async {
        do {
            let response: Currency = try await network.request(
                baseURL: "https://v6.exchangerate-api.com/v6/",
                path: "latest/\(currency)",
                method: .get)
            
            await MainActor.run {
                currenies = response.conversionRates.map { $0.key }
                conversionRates = response.conversionRates
            }
            
            print("@@@ response \(response)")
        } catch {
            print("@@@ error \(error)")
        }
    }
}

// Mock viewModel just for the previews
extension CurrencyConverterViewModel {
    static var preview: CurrencyConverterViewModel {
        let viewModel = CurrencyConverterViewModel(network: NetworkManager(apiKey: ""))
        viewModel.amount = "1000"
        viewModel.convertedAmount = "1100.23"
        viewModel.sourceCurrency = "USD"
        viewModel.targetCurrency = "EUR"
        return viewModel
    }
}
