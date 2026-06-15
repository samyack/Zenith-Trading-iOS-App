//
//  Zenith_TradingApp.swift
//  Zenith Trading
//
//  Created by Samyack on 27/05/26.
//

import SwiftUI
import SwiftData
import FirebaseCore


@main
struct Zenith_TradingApp: App {
    init() {
             FirebaseApp.configure()
             
            
         }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
//            ContentView()
            LoginView()
            
        }
        .modelContainer(sharedModelContainer)
    }
}
