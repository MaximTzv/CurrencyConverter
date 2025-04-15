//
//  CurrencySelectorView.swift
//  CurrencyConverter
//
//  Created by Maxim Tzvetkov on 15.04.25.
//

import SwiftUI

struct CurrencySelectorView: View {
    
    @EnvironmentObject var viewModel: CurrencyConverterViewModel
    @State private var presentSearchList: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("From", selection: $viewModel.pair.from) {
                    ForEach(viewModel.currenies, id: \.self) { item in
                        Text(item)
                    }
                }
                .pickerStyle(.inline)
                
                Button {
                    presentSearchList = true
                } label: {
                    Text("From")
                }
                .sheet(isPresented: $presentSearchList) {
                    CurrencyListView(viewModel: viewModel)
                }

            }
            .padding()
            .navigationTitle("Currency Converter")
        }
        .task {
            await viewModel.fetchRates(for: "EUR")
        }
    }
}

//#Preview {
//    CurrencySelectorView()
//}
