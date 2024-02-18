//
//  BrowserRule.swift
//  Linnet
//
//  Created by Bing-Chang Lai on 2/24/24.
//

import Foundation
import SwiftData

@Model
class BrowserRule {
    var match: String
    var result: String
    var timestamp: Date

    init(match: String, result: String, timestamp: Date) {
      self.match = match
      self.result = result
      self.timestamp = timestamp
    }

    func matches(url: URL) -> Bool {
        if let r = try? Regex(match) {
            return url.absoluteString.contains(r)
        }
        return false
    }
}
