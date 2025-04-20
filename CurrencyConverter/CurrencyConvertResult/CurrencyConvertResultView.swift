//
//  CurrencyConvertResultView.swift
//  CurrencyConverter
//
//  Created by Maxim Tzvetkov on 19.04.25.
//

import SwiftUI

struct CurrencyConvertResultView: View {
    
    @ObservedObject var viewModel: CurrencyConverterViewModel
    @State private var animateSwap = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Converted Amount")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(viewModel.convertedAmount)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    Text(viewModel.targetCurrency ?? "-")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                Text("From \(viewModel.sourceCurrency ?? "-") → To \(viewModel.targetCurrency ?? "-")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            )
            .padding(.horizontal)

            Button(action: {
                withAnimation(.spring()) {
                    animateSwap.toggle()
                }
                Task {
                    viewModel.swapCurrencies()
                }
            }) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.title2)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(animateSwap ? 180 : 0))
                    .padding()
                    .background(Circle().fill(Color.blue.gradient))
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Conversion")
        .background(
            LinearGradient(
                colors: [Color(.systemGray6), Color(.systemGray5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    CurrencyConvertResultView(viewModel: .preview)
}
