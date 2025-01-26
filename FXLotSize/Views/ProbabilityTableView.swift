//
//  ProbabilityTableView.swift
//  FXLotSize
//
//  Created by primagest on 2024/12/24.
//

import SwiftUI
import Charts
import SwiftData

struct Probability: Identifiable {
    var id = UUID()
    let rewardRatio: String
    let percentage: String
    let probability: String
}

enum GraphType {
    case lineGrph, tableGrph
}

struct ProbabilityTableView: View {
    
    let list: [Probability]
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [DatabaseUserModel]
    @State private var selectedGraphType: GraphType = .lineGrph
    @State private var isShowEditLossRatio = false
    @State var isPurchased: Bool = false

    @Binding var lossRatio: Int
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text("bankruptcProbabilityTable")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                Spacer()
                
                ToggleButton(selectedGraphType: $selectedGraphType)
            }
            .padding(.bottom)
            
            HStack {
                Spacer()
                
                ZStack(alignment: .topTrailing) {
                    Button {
                        isShowEditLossRatio = isPurchased ? true : false
                    } label: {
                        HStack {
                            Text("LossRatio")
                            Text("\(lossRatio) %")
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.mint, lineWidth: 2) // 枠線の色と太さを指定
                        )
                    }
                    .padding()
                    
                    if(!isPurchased) {
                        Image(systemName: "lock.fill")
                            .font(.title)
                            .foregroundStyle(Color.orange)
                            .padding(.horizontal, 5)
                    }
                }
            }
            .padding(.bottom)
            
            if(selectedGraphType == .lineGrph) {
                ZStack {
                    VStack(spacing: 10) {
                        HStack(spacing: 0) {
                            if(!list.filter { Double($0.probability) != nil }.isEmpty) {
                                Text("bankruptcProbability")
                                    .rotationEffect(.degrees(-90))
                            }
                            Chart(
                                list.filter { Double($0.probability) != nil } // Doubleに変換可能な値だけ残す
                            ) { item in
                                LineMark(
                                    x: .value("value", Int(item.percentage) ?? 0),
                                    y: .value("Category", Double(item.probability) ?? 0.0)
                                )
                            }
                            Spacer()
                            Spacer()
                        }
                        if(!list.filter { Double($0.probability) != nil }.isEmpty) {
                            Text("winningPercentage")
                        }
                    }
                }
                .frame(height: 250) // 高さを親コンテナで強制
                .padding()
            }
            
            if(selectedGraphType == .tableGrph) {
                // ヘッダー行
                HStack(spacing: 0) {
                    Text("ProfitAndLossRatio")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(Color.black)
                    Text("winningPercentage")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(Color.black)
                    Text("bankruptcProbability")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(Color.black)
                }
                .padding()
                .background(Color.yellow)
                
                // データ行
                ForEach(list.indices, id: \.self) { i in
                    HStack(spacing: 0) {
                        Text(list[i].rewardRatio)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(list[i].percentage + "%")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(list[i].probability + "%")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 4) // 各行の上下余白
                    .background(i % 2 == 0 ? Color.gray.opacity(0.1) : Color.clear) // 行の背景を交互に設定
                }
            }
        }
        .padding()
        .sheet(isPresented: $isShowEditLossRatio) {
            Picker("set ratio", selection: $lossRatio) {
                ForEach(1...100, id: \.self) { number in
                    Text("\(number)")
                        .font(.title)
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.fraction(0.5)]) // ハーフモーダルに設定
            .presentationDragIndicator(.visible) // 上部のドラッグインジケーターを表示
            
        }
        .onAppear {
            if let firstUser = users.first {
                isPurchased = firstUser.purchased
            }
        }
    }
}

#Preview {
    RiskRewardView()
}
