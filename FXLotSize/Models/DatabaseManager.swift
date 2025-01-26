//
//  DatabaseManager.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/06.
//

import Foundation
import SwiftData

class DatabaseManager {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func updateUserModel(currency: String, lossPercent: Int, oneLotSize: Int, purchased: Bool) async throws {
        let fetchDescriptor = FetchDescriptor<DatabaseUserModel>()
        if let models = try? modelContext.fetch(fetchDescriptor) {
            models.first?.currency = currency
            models.first?.lossPercent = lossPercent
            models.first?.oneLotSize = oneLotSize
            models.first?.purchased = purchased
        }
        try? modelContext.save()
    }
    
    // 特定の通貨ペアの価格を更新
    func setFirstInsert() async throws -> Bool {
        // モデルの取得
        let fetchDescriptor = FetchDescriptor<DatabaseUserModel>()
        let count = try? modelContext.fetchCount(fetchDescriptor)
        let gssInstance = GoogleSheetService.instance
        let res = await gssInstance.callGoogleSheetAPI()
        if res {
            if count == .zero {
                let user = DatabaseUserModel(id: 0, currency: "JPY", purchased: false, lossPercent: 5, oneLotSize: 100000)
                modelContext.insert(user)
                for item in gssInstance.list {
                    print(item.pairName, item.pairRate)
                    let pair = DatabaseCurrencyPairModel(name: item.pairName,
                                                         price: item.pairRate,
                                                         selected: item.pairName == "USD/JPY",
                                                         favorited: item.pairName == "USD/JPY" || item.pairName == "EUR/USD" || item.pairName == "GBP/JPY",
                                                         pairFullName: item.pairFullName)
                    modelContext.insert(pair)
                }
                print("初期保存")
            }else {
                for item in gssInstance.list {
                    print(item.pairName, item.pairRate)
                    try? updatePrice(name: item.pairName, newPrice: item.pairRate)
                }
                print("更新保存")
            }
        }else {
            print("could not callGoogleSheetAPI")
            return false
        }
        try? modelContext.save()
        return true
    }
    
    
    // 特定の通貨ペアの価格を更新
    func updatePrice(name: String, newPrice: Double) throws {
        
        let descriptor = FetchDescriptor<DatabaseCurrencyPairModel>(
            predicate: #Predicate<DatabaseCurrencyPairModel> { model in
                model.pairName == name
            }
        )
        if let models = try? modelContext.fetch(descriptor) {
            models.first?.pairRate = newPrice
        }
    }
    
    func updateSelected(name: String) throws {
        
        let descriptor = FetchDescriptor<DatabaseCurrencyPairModel>(
            predicate: #Predicate { $0.selected == true }
        )

        if let models = try? modelContext.fetch(descriptor) {
            models.first?.selected = false
        }

        let targetDescriptor = FetchDescriptor<DatabaseCurrencyPairModel>(
            predicate: #Predicate<DatabaseCurrencyPairModel> { model in
                model.pairName == name
            }
        )
        if let models = try? modelContext.fetch(targetDescriptor) {
            models.first?.selected = true
        }
        try? modelContext.save()
    }
    
    func updatefavorited(name: String) throws {
        let selectedDescriptor = FetchDescriptor<DatabaseCurrencyPairModel>(
            predicate: #Predicate { $0.selected == true }
        )
        let targetDescriptor = FetchDescriptor<DatabaseCurrencyPairModel>(
            predicate: #Predicate { $0.pairName == name }
        )
        
        if let selectedModel = try? modelContext.fetch(selectedDescriptor).first,
           let targetModel = try? modelContext.fetch(targetDescriptor).first {
            if(!targetModel.favorited) {
                targetModel.favorited = true
            }else {
                if(selectedModel.pairName == targetModel.pairName) {
                    let targetDescriptor = FetchDescriptor<DatabaseCurrencyPairModel>(
                        predicate: #Predicate { $0.favorited == true && $0.selected == false }
                    )
                    if let targetModel = try? modelContext.fetch(targetDescriptor).first {
                        targetModel.selected = true
                    }else {
                        return
                    }
                    selectedModel.selected = false
                    selectedModel.favorited = false
                }else {
                    targetModel.favorited = false
                }
            }
        }
        try? modelContext.save()
    }
}
