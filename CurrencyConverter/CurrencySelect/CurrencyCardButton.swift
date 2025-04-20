//
//  CurrencyCardButton.swift
//  CurrencyConverter
//
//  Created by Maxim Tzvetkov on 20.04.25.
//

import SwiftUI

struct CurrencyCardButton: View {
    
    let title: String
    let image: String
    let backgroundColor: Color
    let foregroundColor: Color
    let actionTap: () -> Void
    
    var body: some View {
        Button(action: actionTap) {
            HStack {
                Image(systemName: image)
                    .font(.title2)
                    .foregroundStyle(foregroundColor)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(16)
    }
}

#Preview {
    CurrencyCardButton(
        title: "Title",
        image: "chevron.right",
        backgroundColor: .accentColor,
        foregroundColor: .green,
        actionTap: {})
}
