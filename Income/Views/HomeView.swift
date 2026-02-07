//
//  ContentView.swift
//  Income
//
//  Created by Adrian Inculet on 08.01.2026.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var showAddTransactionView = false
    @State private var transactionToEdit: TransactionItem?
    @State private var showSettings = false
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<TransactionItem>
    @AppStorage("orderDecending") var orderDecending = false
    @AppStorage("currency") var currency: Currency = .ron
    @AppStorage("filterMinimum") var filterMinimum = 0.0
    @Environment(\.managedObjectContext) private var viewContext
    
    private var displayTransactions: [TransactionItem] {
        let sortedTransactions = orderDecending ? transactions.sorted(by: { $0.wrappedDate < $1.wrappedDate}) : transactions.sorted(by: { $0.wrappedDate > $1.wrappedDate})
        let filteredTransactions = sortedTransactions.filter({ $0.amount > filterMinimum})
        return filteredTransactions
    }
    
    private var expenses: String {
        let sumExpenses = transactions.filter({ $0.wrappedTransactionType == .expense }).reduce(0, { $0 + $1.amount})
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: currency.locale)
        return numberFormatter.string(from: sumExpenses as NSNumber) ?? "0.00"
    }
    
    private var income: String {
        let sumIncome = transactions.filter({ $0.wrappedTransactionType == .income }).reduce(0, { $0 + $1.amount})
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: currency.locale)
        return numberFormatter.string(from: sumIncome as NSNumber) ?? "0.00"
    }
    
    private var total: String {
        let sumExpenses = transactions.filter({ $0.wrappedTransactionType == .expense }).reduce(0, { $0 + $1.amount})
        let sumIncome = transactions.filter({ $0.wrappedTransactionType == .income }).reduce(0, { $0 + $1.amount})
        let total = sumIncome - sumExpenses
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: currency.locale)
        return numberFormatter.string(from: total as NSNumber) ?? "0.00"
    }
    
    fileprivate func FloatButton() -> some View {
        VStack {
            Spacer()
            NavigationLink {
                AddTransactionView()
            } label: {
                Text("+")
                    .font(.largeTitle)
                    .frame(width: 70, height: 70)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 7)
            }
            .background(Color.primaryLightGreen)
            .clipShape(Circle())
        }
    }
    
    fileprivate func BalanceView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primaryLightGreen)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("BALANCE")
                            .font(.caption)
                            .foregroundStyle(Color.white)
                        Text("\(total)")
                            .font(.system(size: 42, weight: .light))
                            .foregroundStyle(Color.white)
                    }
                    Spacer()
                }
                .padding(.top)
               
                HStack(spacing: 25) {
                    VStack(alignment: .leading) {
                        Text("Expense")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.white)
                        Text("\(expenses)")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.white)
                    }
                    VStack(alignment: .leading) {
                        Text("Income")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.white)
                        Text("\(income)")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.white)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .frame(height: 150)
        .padding(.horizontal)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 25) {
                    BalanceView()
                    List {
                        ForEach(displayTransactions) { transaction in
                            Button {
                                transactionToEdit = transaction
                            } label: {
                                TransactionView(transaction: transaction)
                                    .foregroundStyle(.black)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .scrollContentBackground(.hidden)
                }
                FloatButton()
            }
            .navigationTitle("Income")
            .navigationDestination(item: $transactionToEdit, destination: { transactionToEdit in
                AddTransactionView(transactionToEdit: transactionToEdit)
            })
            .navigationDestination(isPresented: $showAddTransactionView, destination: {
                AddTransactionView()
            })
            .sheet(isPresented: $showSettings, content: {
                SettingsView()
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.black)
                    }

                }
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let transactionToDelete = transactions[index]
            viewContext.delete(transactionToDelete)
        }
        
    }
}



#Preview {
    let dataManager = DataManager.sharedPreview
    return HomeView().environment(\.managedObjectContext, dataManager.container.viewContext)
}
