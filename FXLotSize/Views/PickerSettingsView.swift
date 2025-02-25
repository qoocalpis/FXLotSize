//
//  PickerSettingsView.swift
//  FXLotSize
//
//  Created by primagest on 2025/02/09.
//

import SwiftUI

// 設定用のPickerをまとめたView
struct PickerSettingsView: View {
    @Binding var selectedCurrency: String
    @Binding var selectedOneLotSize: String
    @Binding var selectedLossAllowance: String
    
    let currencies = ["USD", "JPY"]
    let constractSizes = ["1000", "5000", "10000", "50000", "100000"]
    let percentList: [String] = (1...100).map { String($0) }
    
    var body: some View {
        VStack {
            SettingCell(
                titleText: Text("AccountCurrency"),
                items: currencies,
                text: $selectedCurrency
            )
            SettingCell(
                titleText: Text("OneLotSize"),
                items: constractSizes,
                text: $selectedOneLotSize
            )
            SettingCell(
                titleText: Text("FixedProfitAndLossAllowance"),
                items: percentList,
                text: $selectedLossAllowance
            )
        }
    }
}
