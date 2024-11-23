//
//  User.swift
//  FXLotSize
//
//  Created by primagest on 2024/09/15.
//

import Foundation
import SwiftData


@Model
class DatabaseUserModel {
    
    @Attribute(.unique)
    var id: Int
    var currency: String
    var purchased: Bool
    var lossPercent: Int
    var oneLotSize: Int
    

    init(id: Int, currency: String, purchased: Bool, lossPercent: Int, oneLotSize: Int) {
        self.id = id
        self.currency = currency
        self.purchased = purchased
        self.lossPercent = lossPercent
        self.oneLotSize = oneLotSize
    }
}
