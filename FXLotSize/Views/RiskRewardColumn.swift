//
//  RiskRewardColumn.swift
//  FXLotSize
//
//  Created by primagest on 2024/12/28.
//

import SwiftUI

struct RiskRewardColumn: View {
    let titleText: Text
    let text: String

    var body: some View {
        VStack {
            titleText
                .font(.headline)
                .foregroundColor(.secondary) // Adapts to light/dark mode
            Text(text)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}
