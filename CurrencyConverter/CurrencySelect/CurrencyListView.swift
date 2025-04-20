//
//  CurrencyListView.swift
//  CurrencyConverter
//
//  Created by Maxim Tzvetkov on 15.04.25.
//

import SwiftUI

enum CurrencySelectionType {
    case source, target
}

struct CurrencyListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CurrencyConverterViewModel
    @State private var searchText: String = ""
    
    let selection: CurrencySelectionType
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { currency in
                    Button {
                        
                        searchText = ""
                        switch selection {
                        case .source:
                            viewModel.sourceCurrency = currency
                        case .target:
                            viewModel.targetCurrency = currency
                        }
                        
                        dismiss()
                        
                    } label: {
                        Text(currency)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Currencies")
        }
        .searchable(text: $searchText) {
            ForEach(searchResults, id: \.self) { result in
                Text(result).searchCompletion(result)
            }
        }
    }
    
    private var searchResults: [String] {
        if searchText.isEmpty {
            return viewModel.currenies
        } else {
            return viewModel.currenies.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    CurrencyListView(viewModel: .preview, selection: .source)
}
