//
//  IncomeApp.swift
//  Income
//
//  Created by Adrian Inculet on 08.01.2026.
//

import SwiftUI
internal import CoreData

@main
struct IncomeApp: App {
    
    let dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
