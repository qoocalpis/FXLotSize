//
//  Item.swift
//  FXLotSize
//
//  Created by primagest on 2024/09/15.
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
