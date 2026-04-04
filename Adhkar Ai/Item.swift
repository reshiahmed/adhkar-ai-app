//
//  Item.swift
//  Adhkar Ai
//
//  Created by Ahmed Reshi on 4.04.2026.
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
