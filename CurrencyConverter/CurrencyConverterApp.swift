//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Maxim Tzvetkov on 15.04.25.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    var body: some Scene {
        WindowGroup {
            
            let network = NetworkManager(apiKey: "5817abe186bbe4d2849164e6")
            let viewModel = CurrencyConverterViewModel(network: network)
            CurrencySelectorView()
                .environmentObject(viewModel)
        }
    }
}
