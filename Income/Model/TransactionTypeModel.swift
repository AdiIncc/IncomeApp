//
//  TransactionTypeModel.swift
//  Income
//
//  Created by Adrian Inculet on 08.01.2026.
//

import Foundation

enum TransactionType: Int, CaseIterable, Identifiable {
    case income, expense
    var id: Self { self }
    
    var title: String {
        switch self {
        case .income:
            return "Income"
        case .expense:
            return "Expense"
        }
    }
}
