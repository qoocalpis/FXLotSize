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
    var lossPercent: Int
    var oneLotSize: Int
    

    init(id: Int, currency: String, lossPercent: Int, oneLotSize: Int) {
        self.id = id
        self.currency = currency
        self.lossPercent = lossPercent
        self.oneLotSize = oneLotSize
    }
}
