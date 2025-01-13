//
//  SettingCell.swift
//  FXLotSize
//
//  Created by primagest on 2024/12/31.
//

import SwiftUI

struct SettingCell: View {
    
    let titleText: Text
    let items: [String]
    @Binding var text: String
    
    var body: some View {
        HStack {
            
            titleText
                .font(.headline)
            
            Spacer()
            
            Picker("", selection: $text) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .tag(item)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}
