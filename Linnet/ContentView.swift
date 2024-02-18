//
//  ContentView.swift
//  Linnet
//
//  Created by Bing-Chang Lai on 2/17/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [BrowserRule]

    let workspace = NSWorkspace.shared

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Form {
                            TextField(text: .init(
                                get: { item.match },
                                set: { item.match = $0 }
                            )) {
                                Text("Match")
                            }
                            Picker("Browser", selection: .init(
                                get: { item.result },
                                set: { item.result = $0 }
                            )) {
                                Text("Safari").tag("com.apple.Safari")
                                Text("FireFox").tag("org.mozilla.firefox")
                                Text("Chrome").tag("com.google.Chrome")
                                Text("Microsoft Edge").tag("com.microsoft.edgemac")
                            }
                            Text("\(item.timestamp)")
                        }
                        .frame(width: 320, height: 240)
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .onOpenURL { url in
            if let browserBundleId = getOpeningBrowserId(url: url) {
                print("opening: \(url) in \(browserBundleId)")
                if let appURL = workspace.urlForApplication(withBundleIdentifier: browserBundleId) {
                    workspace.open([url], withApplicationAt: appURL, configuration: NSWorkspace.OpenConfiguration(), completionHandler: { (app, error) in
                        if let error = error {
                            print("Error opening file: \(error.localizedDescription)")
                        } else {
                            print("File opened successfully with \(app?.localizedName ?? "Unknown Application")")
                        }
                    })
                } else {
                    print("Unable to locate \(browserBundleId)")
                }
            } else {
                print("No browser")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = BrowserRule(match: ".*", result: "com.apple.Safari", timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }

    // decide which browser should be used to open a link
    private func getOpeningBrowserId(url: URL) -> String? {
        //var browserMappings = Array<BrowserRule>()
        // browserMappings.append(BrowserRule(match: "^https?://www.google.com/?.*$", result: "org.mozilla.firefox"))

        // Check rules
        for rule in items {
            if rule.matches(url: url) {
                return rule.result
            }
        }

        // Return defaults
        return "com.apple.Safari"
    }
}

#Preview {
    ContentView()
        .modelContainer(for: BrowserRule.self, inMemory: true)
}
