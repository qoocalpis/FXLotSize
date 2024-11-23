//
//  TextFieldCell.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/09.
//

import SwiftUI

struct TextFieldCell: View {
    @Binding var text: String
    let titleView: Text
    let subTitleView: Text
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    titleView
                    Spacer()
                    subTitleView
                }
                HStack {
                    Spacer()
                    TextField("", text: $text)
                        .font(.title2)
                        .fontWeight(.bold)
                        .keyboardType(.numberPad)
                        .frame(width: 200)
                        .overlay(
                            Rectangle()
                                .frame(height: 1),
                            alignment: .bottom
                        )
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .overlay(
            UnevenRoundedRectangle(bottomTrailingRadius: 10,
                                   topTrailingRadius: 10)
                .stroke(lineWidth: 2) // ボーダーの色と線幅を指定
        )
        .padding(.trailing)
        .padding(.bottom)
    }
}

#Preview {
    HomeTabView()
}

