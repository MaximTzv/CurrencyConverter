//
//  CurrencySelectorView.swift
//  CurrencyConverter
//
//  Created by Maxim Tzvetkov on 15.04.25.
//

import SwiftUI

struct CurrencySelectorView: View {
    
    @EnvironmentObject var viewModel: CurrencyConverterViewModel
    
    @State private var presentSourceList: Bool = false
    @State private var presentTargetList: Bool = false
    @State private var showConvert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text("From")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CurrencyCardButton(
                            title: viewModel.sourceCurrency ?? "Select Currency",
                            image: "arrow.up.circle",
                            backgroundColor: Color.blue.opacity(0.1),
                            foregroundColor: .blue
                        ) {
                            presentSourceList = true
                        }
                    }

                    VStack(spacing: 16) {
                        Text("To")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CurrencyCardButton(
                            title: viewModel.targetCurrency ?? "Select Currency",
                            image: "arrow.down.circle",
                            backgroundColor: Color.green.opacity(0.1),
                            foregroundColor: .green
                        ) {
                            presentTargetList = true
                        }
                    }

                    VStack(spacing: 8) {
                        Text("Amount")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("Enter amount", text: $viewModel.amount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                    }

                    Button {
                        guard let source = viewModel.sourceCurrency else { return }
                        
                        Task {
                            await viewModel.fetchRates(for: source)
                            await viewModel.convertAmount()
                            showConvert = true
                        }
                    } label: {
                        Text("Convert")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(14)
                            .shadow(color: .accentColor.opacity(0.3), radius: 6, x: 0, y: 4)
                    }
                    .disabled(viewModel.sourceCurrency == nil || viewModel.targetCurrency == nil || viewModel.amount.isEmpty)
                    .opacity(viewModel.sourceCurrency == nil || viewModel.targetCurrency == nil || viewModel.amount.isEmpty ? 0.5 : 1)

                    Spacer()
                }
                .padding()
                .navigationTitle("Currency Converter")
                .navigationDestination(isPresented: $showConvert) {
                    CurrencyConvertResultView(viewModel: viewModel)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $presentSourceList) {
            CurrencyListView(viewModel: viewModel, selection: .source)
        }
        .sheet(isPresented: $presentTargetList) {
            CurrencyListView(viewModel: viewModel, selection: .target)
        }
        .task {
            await viewModel.fetchRates(for: "USD")
        }
    }
}

#Preview {
    CurrencySelectorView()
        .environmentObject(CurrencyConverterViewModel(network: NetworkManager(apiKey: "")))
}
