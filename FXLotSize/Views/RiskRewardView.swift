//
//  RiskRewardView.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/07.
//

import SwiftUI
import Charts

struct RiskRewardView: View {
    
    
    var body: some View {
        VStack {
            Chart {
                BarMark(
                    x: .value("value", 50),
                    y: .value("Category", "risk")
                )
                .foregroundStyle(Color.red)
                BarMark(
                    x: .value("value", 100),
                    y: .value("Category", "reward")
                )
            }
            .padding()
            Button {
                
            } label: {
                Text("profitLossPipsSetting")
                    .padding()
                    .padding(.horizontal)
                    .background(Color.teal)
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .cornerRadius(10)
            }
            
        }
    }
}

#Preview {
    RiskRewardView()
}
