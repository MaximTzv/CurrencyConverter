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

struct CurrencyPair: Equatable {
    var from: String
    var to: String
    
    mutating func swapCurrencies() {
        swap(&from, &to)
    }
}

class CurrencyConverterViewModel: ObservableObject {
    
    @Published var pair = CurrencyPair(from: "USD", to: "EUR")
    @Published var amount: String = ""
    @Published var convertedAmount: String = ""
    
    @Published var baseCode: String = ""
    @Published var currenies: [String] = []
    
    @Published var errorMessage: String?
    
    private let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func fetchRates(for currency: String) async {
        do {
            let response: Currency = try await network.request(
                baseURL: "https://v6.exchangerate-api.com/v6/",
                path: "latest/\(currency)",
                method: .get)
            
            baseCode = response.baseCode
            currenies = response.conversionRates.map { $0.key }
            
            pair = CurrencyPair(from: baseCode, to: baseCode)
            
            print("@@@ response \(response)")
        } catch {
            print("@@@ error \(error)")
        }
    }
}
