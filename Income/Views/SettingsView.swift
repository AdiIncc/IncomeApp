//
//  SettingsView.swift
//  Income
//
//  Created by Adrian Inculet on 13.01.2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("orderDecending") var orderDescending = false
    @AppStorage("currency") var currency: Currency = .ron
    @AppStorage("filterMinimum") var filterMinimum = 0.0
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: currency.locale)
        return numberFormatter
    }
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Toggle(isOn: $orderDescending) {
                        Text("Order \(orderDescending ? "Earliest" : "Latest")")
                    }
                }
                HStack {
                    Picker("Currency", selection: $currency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.title)
                                .tag(currency)
                        }
                    }
                }
                HStack {
                    Text("Filter Minimum")
                    TextField("", value: $filterMinimum, formatter: numberFormatter)
                        .multilineTextAlignment(.trailing)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
