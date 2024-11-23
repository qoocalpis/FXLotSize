//
//  CurrencyPairDatabaseModel.swift
//  FXLotSize
//
//  Created by primagest on 2024/09/15.
//

import Foundation
import SwiftData


@Model
final class DatabaseCurrencyPairModel {
  
  @Attribute(.unique)
  var pairName: String
    
  var pairRate: Double
  var selected: Bool
  var favorited: Bool
    var pairFullName: String
    
    init(name: String, price: Double, selected: Bool, favorited: Bool, pairFullName: String) {
        self.pairName = name
        self.pairRate = price
        self.selected = selected
        self.favorited = favorited
        self.pairFullName = pairFullName
    }
}
