//
//  ToggleButton.swift
//  FXLotSize
//
//  Created by primagest on 2024/12/28.
//


import SwiftUI

struct ToggleButton: View {

    private let width: CGFloat = 200.0
    private let height: CGFloat = 40.0
    private let selectedColor: Color = .white
    private let normalColor: Color = .black.opacity(0.54)
    @Binding var selectedGraphType: GraphType


    var body: some View {
        ZStack {
            // Gray background
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.gray)
                .frame(width: width, height: height)

            // Green selection background
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.green.opacity(0.5))
                .frame(width: width * 0.5, height: height)
                .offset(x: selectedGraphType == .lineGrph ? -width * 0.25 : width * 0.25)
                .animation(.easeInOut(duration: 0.3), value: selectedGraphType)

            // Buttons
            HStack(spacing: 0) {
                // Line Graph Button
                Button(action: {
                    selectedGraphType = .lineGrph
                }) {
                    Text("LineGraph") // Replace with localized string
                        .fontWeight(.bold)
                        .foregroundColor(selectedGraphType == .lineGrph ? selectedColor : normalColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Table Button
                Button(action: {
                    selectedGraphType = .tableGrph
                }) {
                    Text("Table") // Replace with localized string
                        .fontWeight(.bold)
                        .foregroundColor(selectedGraphType == .tableGrph ? selectedColor : normalColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(width: width, height: height)
        }
        .frame(width: width, height: height)
    }
}


//struct ToggleButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ToggleButton()
//    }
//}
