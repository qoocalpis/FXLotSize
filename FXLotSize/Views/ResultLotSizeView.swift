//
//  ResultLotSizeView.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/26.
//

import SwiftUI

struct ResultLotSizeView: View {
    
    let acountBarrance: String
    let lossAllowancePercent: String
    let lossAllowableAmount: String
    let stopLoss: String
    let currencyPair: String
    let rate: String
    let oneLotSize: String
    
    var body: some View {
        VStack {
            
            Text("appropriateLot")
                .font(.title2)
                .fontWeight(.heavy)
            
            HStack(alignment: .bottom) {
                
                Text("1.15")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Text("lot")
                    .font(.title)
                    .fontWeight(.black)
            }
            
            ResultRowView(title: Text("acountBarrance"), resultText: Text(acountBarrance))
            ResultRowView(title: Text("lossTolerancePercent"), resultText: Text(lossAllowancePercent + "%"))
            ResultRowView(title: Text("lossAllowance"), resultText: Text(lossAllowableAmount))
            ResultRowView(title: Text("stopLoss"), resultText: Text(stopLoss + " pips"))
            ResultRowView(title: Text("currencyPair"), resultText: Text(currencyPair))
            ResultRowView(title: Text("rate"), resultText: Text(rate))
            ResultRowView(title: Text("1 Lot size"), resultText: Text(oneLotSize))
        }
    }
}

struct ResultRowView: View {
    
    let title: Text
    let resultText: Text
    
    var body: some View {
        HStack {
            title
                .font(.title3)
            Spacer()
            resultText
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding()
        .padding(.horizontal)
    }
}

#Preview {
    ResultLotSizeView(acountBarrance: "10000",
                      lossAllowancePercent: "10000",
                      lossAllowableAmount: "10000",
                      stopLoss: "10000",
                      currencyPair: "USD/JPY",
                      rate: "10000",
                      oneLotSize: "10000")
}
