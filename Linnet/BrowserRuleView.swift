//
//  BrowserRuleView.swift
//  Linnet
//
//  Created by Bing-Chang Lai on 2/24/24.
//

import SwiftUI

struct BrowserRuleView: View {
    @State var item: BrowserRule

    var body: some View {
        Form {
            TextField(text: .init(
                get: { self.item.match },
                set: { self.item.match = $0 }
            )) {
                Text("Match")
            }
            TextField(text: .init(
                get: { self.item.result },
                set: { self.item.result = $0 }
            )) {
                Text("Browser")
            }
            Text("\(item.timestamp)")
        }
    }
}

#Preview {
    BrowserRuleView(item: BrowserRule(match: "matches", result: "com.apple.Safari", timestamp: Date()))
}
