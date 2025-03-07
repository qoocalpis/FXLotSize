//
//  FXLotSizeApp.swift
//  FXLotSize
//
//  Created by primagest on 2024/09/15.
//

import SwiftUI
import SwiftData

@main
struct FXLotSizeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DatabaseUserModel.self,
            DatabaseCurrencyPairModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FirstLoadingRateView()
        }
        .modelContainer(sharedModelContainer)
    }
}
