//
//  Currency.swift
//  Income
//
//  Created by Adrian Inculet on 13.01.2026.
//

import Foundation

enum Currency: Int, CaseIterable {
    case ron, pounds
    
    var title: String {
        switch self {
        case .ron:
            return "RON"
        case .pounds:
            return "Pounds"
        }
    }
    
    var locale: String {
        switch self {
        case .ron:
            return "ro_RO"
        case .pounds:
            return "en_GB"
        }
    }
}
