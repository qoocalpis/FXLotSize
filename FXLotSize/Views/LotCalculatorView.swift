//
//  SecondView.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/06.
//

import SwiftUI
import SwiftData

struct LotCalculatorView: View {
    
    @Binding var isShowCurrencyPairListView: Bool
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [DatabaseUserModel]
    @Query(filter: #Predicate<DatabaseCurrencyPairModel> { databaseCurrencyPairModel in
        databaseCurrencyPairModel.selected == true
    }) private var currencyPairs: [DatabaseCurrencyPairModel]
    
    @State private var acountBarranceText: String = ""
    @State private var lossAllowanceText: String = ""
    @State private var stopLossText: String = ""
    @State private var isAcountBarrance = false
    @State private var isLossAllowance = false
    @State private var isStopLoss = false
    @State private var lossAllowableAmountText: String = ""
    @State private var lotSizeText: String = ""
    @State private var isShowResultLotSizeViewSheet = false
    @State private var firstOnAppearTrigger = false
    
    var body: some View {
        GeometryReader { geometryProxy in
            let height = geometryProxy.size.height
            VStack {
                
                SelectedCurrencyPairView(currencyPairs: currencyPairs,
                                         isShowCurrencyPairListView: $isShowCurrencyPairListView)
                .frame(height: height * 0.25)
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: .zero) {
                        // 最初の要素を取得
                        if let user = users.first {
                            TextFieldCell(text: $acountBarranceText,
                                          titleView: Text("acountBarrance"),
                                          subTitleView: Text("(\(user.currency))"))
                        }else {
                            TextFieldCell(text: $acountBarranceText,
                                          titleView: Text("acountBarrance"),
                                          subTitleView: Text("(USD)"))
                        }
                        TextFieldCell(text: $lossAllowanceText,
                                      titleView: Text("lossAllowance"),
                                      subTitleView: Text("(%)"))
                        
                        TextFieldCell(text: $stopLossText,
                                      titleView: Text("stopLoss"),
                                      subTitleView: Text("(pips)"))
                        
                        // ボタン
                        Button(action: {
                            print("ボタンが押されました")
                            calculate()
                        }) {
                            Text("calculation")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .background(
                                    isAcountBarrance && isLossAllowance && isStopLoss ?
                                    Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
                .padding(.bottom, 10) // 下部に余裕をもたせる
                .onTapGesture {
                    // 背景をタップした時にキーボードを閉じる
                    hideKeyboard()
                }
            }
            .onAppear() {
                if let user = users.first {
                    if (!firstOnAppearTrigger) {
                        lossAllowanceText = String(user.lossPercent)
                        firstOnAppearTrigger.toggle()
                    }
                }
            }
            .onChange(of: acountBarranceText) {
                // 最初の文字が"0"の場合、その文字を削除
                if acountBarranceText.hasPrefix("0") {
                    acountBarranceText = String(acountBarranceText.dropFirst())
                }
                // 8桁以上の場合はそれ以上の文字を削除
                if acountBarranceText.count > 8 {
                    acountBarranceText = String(acountBarranceText.prefix(8))
                }
                isAcountBarrance = acountBarranceText.isEmpty ? false : true
            }
            .onChange(of: lossAllowanceText) {
                // 最初の文字が"0"の場合、その文字を削除
                if lossAllowanceText.hasPrefix("0") {
                    lossAllowanceText = String(lossAllowanceText.dropFirst())
                }
                // 2桁以上の場合は100
                if lossAllowanceText.count > 2 {
                    lossAllowanceText = "100"
                }
                isLossAllowance = lossAllowanceText.isEmpty ? false : true
            }
            .onChange(of: stopLossText) {
                // 最初の文字が"0"の場合、その文字を削除
                if stopLossText.hasPrefix("0") {
                    stopLossText = String(stopLossText.dropFirst())
                }
                // 4桁以上入力不可
                if stopLossText.count > 4 {
                    stopLossText = String(stopLossText.prefix(4))
                }
                isStopLoss = stopLossText.isEmpty ? false : true
            }
            .sheet(isPresented: $isShowResultLotSizeViewSheet) {
                if let user = users.first,
                   let currencyPair = currencyPairs.first{
                    ResultLotSizeView(lotSizeText: lotSizeText,
                                      acountBarrance: acountBarranceText,
                                      lossAllowancePercent: lossAllowanceText,
                                      lossAllowableAmount: lossAllowableAmountText,
                                      stopLoss: stopLossText,
                                      currencyPair: currencyPair.pairName,
                                      rate: String(currencyPair.pairRate),
                                      oneLotSize: String(user.oneLotSize))
                }
            }
        }
    }
    
    func calculate() {
        // checkProperty() を呼び出し、falseの場合は早期リターン
        guard isAcountBarrance && isLossAllowance && isStopLoss else { return }
        
        guard let user = users.first else { return }
        guard let currencyPair = currencyPairs.first else { return }
        let accountCurrency = user.currency
        guard let accountBalance = Int(acountBarranceText) else { return }
        guard let percent = Double(lossAllowanceText) else { return }
        let oneLot = user.oneLotSize
        guard let pips = Int(stopLossText) else { return }
        
        let lossAllowableAmount = Double(accountBalance) * percent / 100
        var baseRate: Double = 0.0
        let endCurrency = String(currencyPair.pairName.suffix(3))
        
        let list = GoogleSheetService.instance.list
        // 通貨ペアを検索
        let firstCurrencyPair = list.first { $0.pairName == endCurrency + "/" + accountCurrency }
        
        // 決済通貨が口座通貨と同じ場合
        if endCurrency == accountCurrency {
            baseRate = 1.0
        } else {
            // 決済通貨が口座通貨と違う場合
            if accountCurrency == "JPY" {
                if let firstCurrencyPair = firstCurrencyPair {
                    baseRate = firstCurrencyPair.pairRate * 0.01
                } else {
                    debugPrint("レートが算出できませんでした")
                    return
                }
            }
            if accountCurrency == "USD" {
                if let firstCurrencyPair = firstCurrencyPair {
                    baseRate = firstCurrencyPair.pairRate
                } else {
                    let secondCurrencyPair = list.first { $0.pairName == accountCurrency + "/" + endCurrency }
                    if let secondCurrencyPair = secondCurrencyPair {
                        baseRate = 1.0 / secondCurrencyPair.pairRate * (endCurrency == "JPY" ? 100.0 : 1.0)
                    } else {
                        debugPrint("レートが算出できませんでした")
                        return
                    }
                }
            }
        }
        
        // oneLotの値に基づいてbaseRateを調整
        switch oneLot {
        case 1000:
            baseRate *= 10
        case 10000:
            baseRate *= 100
        default:
            baseRate *= 1000
        }
        
        // 計算結果を格納する変数
        var result: Double
        result = lossAllowableAmount / Double(pips) / baseRate
        
        // oneLotの特定の値に応じて調整
        if oneLot == 5000 {
            result *= 0.05
        }
        if oneLot == 50000 {
            result *= 0.5
        }
        if accountCurrency == "USD" && currencyPair.pairName != "XAU/USD" {
            result *= 100
        }
        // 数値を四捨五入して小数点第2位までフォーマット
        lotSizeText = String(format: "%.2f", result)
        lossAllowableAmountText = String(Int(lossAllowableAmount))
        isShowResultLotSizeViewSheet  = true
    }
}


#Preview {
    LotCalculatorView(isShowCurrencyPairListView: .constant(false))
}
