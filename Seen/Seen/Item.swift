//
//  Item.swift
//  Seen
//
//  Created by Preetham Ramesh on 3/18/24.
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
