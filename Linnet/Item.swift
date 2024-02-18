//
//  Item.swift
//  Linnet
//
//  Created by Bing-Chang Lai on 2/17/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
