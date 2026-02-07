//
//  DataManager.swift
//  Income
//
//  Created by Adrian Inculet on 13.01.2026.
//

import Foundation
import CoreData

class DataManager {
    
    let container = NSPersistentContainer(name: "IncomeData")
    static let shared = DataManager()
    static var sharedPreview: DataManager = {
        let manager = DataManager(inMemory: true)
        let transaction = TransactionItem(context: manager.container.viewContext)
        transaction.title = "Lunch"
        transaction.amount = 5
        transaction.type = Int16(TransactionType.expense.rawValue)
        transaction.date = Date()
        transaction.id = UUID()
        return manager
    }()
    
    private init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storedDescription, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}
