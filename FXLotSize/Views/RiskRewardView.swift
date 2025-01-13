//
//  RiskRewardView.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/07.
//

import SwiftUI
import Charts

struct RiskRewardView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var isSheetCustomKeyboardsView = false
    @State var riskString: String = "0"
    @State var rewardString: String = "0"
    @State var lossRatio: Int = 2
    @State var riskRatio: Double = .zero
    @State var rewardRatio: Double = .zero
    @State var list: [Probability] = []
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Chart {
                        BarMark(
                            x: .value("value", Int(riskString)!),
                            y: .value("Category", "risk")
                        )
                        .foregroundStyle(Color.red)
                        BarMark(
                            x: .value("value", Int(rewardString)!),
                            y: .value("Category", "reward")
                        )
                    }
                    .animation(.easeInOut, value: riskString) // アニメーションをトリガーに追加
                    .animation(.easeInOut, value: rewardString) // アニメーションをトリガーに追加
                }
                .frame(height: 250) // 高さを親コンテナで強制
                .padding()
                
                ZStack {
                    // Background container
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color.black : Color.white)
                        .shadow(
                            color: colorScheme == .dark
                            ? Color(UIColor(white: 0.7, alpha: 1)) // Dark mode shadow
                            : Color(UIColor(white: 0.4, alpha: 1)), // Light mode shadow
                            radius: 1,
                            x: 0,
                            y: 0
                        )
                    
                    // Content
                    HStack(spacing: .zero) {
                        Spacer()
                        RiskRewardColumn(titleText: Text("risk"), text: "\(riskRatio.formattedString())") // Replace with localized strings
                        Spacer()
                        RiskRewardColumn(titleText: Text(""), text: ":")
                        Spacer()
                        RiskRewardColumn(titleText: Text("reward"), text: "\(rewardRatio.formattedString())")  // Replace with localized strings
                        Spacer()
                    }
                    .padding(10)
                }
                .padding(5)
                
                Button {
                    isSheetCustomKeyboardsView.toggle()
                } label: {
                    Text("profitLossPipsSetting")
                        .padding()
                        .padding(.horizontal)
                        .background(Color.teal)
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                        .cornerRadius(10)
                }
                .padding()
                
                ProbabilityTableView(list: list, lossRatio: $lossRatio)
            }
        }
        .frame(maxHeight: .infinity) // 親の高さを調整
        .onAppear() {
            list = onCalculateContinuedLossProbability()
        }
        .onChange(of: rewardString, { oldValue, newValue in
            list = onCalculateContinuedLossProbability()
            if(riskString != "0") {
                calculateRatio()
            }
        })
        .onChange(of: riskString, { oldValue, newValue in
            list = onCalculateContinuedLossProbability()
            if(rewardString != "0") {
                calculateRatio()
            }
        })
        .onChange(of: lossRatio, { oldValue, newValue in
            list = onCalculateContinuedLossProbability()
        })
        .sheet(isPresented: $isSheetCustomKeyboardsView) {
            CustomKeyboardsView(riskString: $riskString,
                                rewardString: $rewardString)
            .presentationDetents([.fraction(0.65), .large])
            .presentationDragIndicator(.visible) // ドラッグインジケータを表示
        }
    }
    
    func calculateRatio() {
        if let risk = Double(riskString), let reward = Double(rewardString) {
            rewardRatio = reward / risk
            riskRatio = 1
        }
    }
    
    func onCalculateContinuedLossProbability() -> [Probability] {
        let percentList: [String] = (1...100).map { String($0) }
        guard lossRatio != .zero else { return [] }
        let n: Double = 1 // 資金
        let b = Double(lossRatio) / 100.0
        
        guard riskString != "0" && rewardString != "0" else { return [] }
        
        let k = Double(rewardString)! / Double(riskString)!
        
        var list: [Probability] = []
        
        for p in percentList {
            guard let probability = solveEquation(p: Double(p)! / 100, k: k) else {
                list.append(Probability(rewardRatio: String(format: "%.1f", k), percentage: p, probability: "error"))
                continue
            }
            
            let Q = pow(probability, n / b)
            var res = String(format: "%.1f", Q * 100)
            
            // 小数点以下が.0の場合は削除
            if res.hasSuffix(".0") {
                res = String(res.dropLast(2))
            }
            
            let item = Probability(rewardRatio: String(format: "%.1f", k), percentage: p, probability: res)
#if DEBUG
            print("方程式の解 X: \(probability)")
            print("破産確率 Q(n): \(Q)")
#endif
            
            list.append(item)
        }
        
        return list
    }
    
    func solveEquation(p: Double, k: Double) -> Double? {
        // 初期値を設定
        var X: Double = 0.0
        
        // 収束条件や反復回数の設定
        let epsilon = 1e-6
        let maxIterations = 1000
        var iteration = 0
        
        // 反復により方程式を解く
        while iteration < maxIterations {
            let nextX = p * pow(X, 1 + k) + (1 - p)
            // 収束条件を満たせば結果を返す
            if abs(X - nextX) < epsilon {
                return nextX
            }
            // 次の反復に進む
            X = nextX
            iteration += 1
        }
        
        // 収束しない場合は nil を返す（エラーハンドリング）
        return nil
    }
}

#Preview {
    RiskRewardView()
}


// Double型に拡張を追加
extension Double {
    /// 小数点第2位で四捨五入し、少数点以下の0を非表示にするStringを返す
    func formattedString() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0 // 最小小数点以下桁数
        formatter.maximumFractionDigits = 2 // 最大小数点以下桁数
        formatter.numberStyle = .decimal

        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
