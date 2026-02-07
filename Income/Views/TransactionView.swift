//
//  TransactionView.swift
//  Income
//
//  Created by Adrian Inculet on 08.01.2026.
//

import SwiftUI
import CoreData

struct TransactionView: View {
    
    let transaction: TransactionItem
    @AppStorage("currency") var currency: Currency = .ron

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("\(transaction.displayDate)")
                    .font(.system(size: 14))
                Spacer()
            }
            .padding(.vertical, 5)
            .background(Color.lightGrayShade.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            HStack {
                Image(systemName: transaction.wrappedTransactionType == .income ? "arrow.up" : "arrow.down.forward")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(transaction.wrappedTransactionType == .income ? Color.green : Color.red)
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(transaction.wrappedTitle)
                            .font(.system(size: 15, weight: .bold))
                        Spacer()
                        Text(String(transaction.displayAmount(currency: currency)))
                            .font(.system(size: 15, weight: .bold))
                    }
                    Text("Completed")
                        .font(.system(size: 14))
                }
            }
        }
        .listRowSeparator(.hidden)
    }
}

//
//#Preview {
//    TransactionView(transaction: Transaction(title: "Apple", type: .expense, amount: 5.00, date: Date()))
//}
