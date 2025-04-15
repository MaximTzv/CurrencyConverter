//
//  CurrencyListView.swift
//  CurrencyConverter
//
//  Created by Maxim Tzvetkov on 15.04.25.
//

import SwiftUI

struct CurrencyListView: View {
    
    @ObservedObject var viewModel: CurrencyConverterViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.currenies, id: \.self) { currency in
                    Text(currency)
                        .font(.headline)
                }
            }
            .navigationTitle("Currensies")
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

//#Preview {
//    CurrencyListView()
//}
