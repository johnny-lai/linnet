//
//  LinnetApp.swift
//  Linnet
//
//  Created by Bing-Chang Lai on 2/17/24.
//

import SwiftUI
import SwiftData

@main
struct LinnetApp: App {
    let workspace = NSWorkspace.shared

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BrowserRule.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {}
        }
    }
}
