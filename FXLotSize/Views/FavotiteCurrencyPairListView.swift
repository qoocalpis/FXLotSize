//
//  CurrencyPairListView.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/28.
//

import SwiftUI
import SwiftData


struct FavotiteCurrencyPairListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate { $0.favorited == true },
            sort: \DatabaseCurrencyPairModel.pairName,
            order: .forward
        ) private var currencyPairs: [DatabaseCurrencyPairModel]
        
    
//    @State private var selectedItem: Int = 0
    @State private var isShowCurrencyPairListView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<currencyPairs.count, id: \.self) { index in
                    ZStack {
                        HStack {
                            Text(currencyPairs[index].pairName)
                                .fontWeight(.bold)
                                .monospaced()
                            Spacer()
                            if(currencyPairs[index].pairName.prefix(3) != "XAU") {
                                Text(attributedString(for: String(format: currencyPairs[index].pairName.suffix(3) == "JPY" ? "%.3f" : "%.5f", currencyPairs[index].pairRate)))
                                    .monospacedDigit()
                            }else {
                                Text(attributedXAUString(for: String(format: "%.2f", currencyPairs[index].pairRate)))
                                    .monospacedDigit()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        
                        HStack {
                            Image("\(currencyPairs[index].pairName.prefix(3))")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 47)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                .clipShape(Circle())
                            Text("/")
                                .font(.title)
                            Image("\(currencyPairs[index].pairName.suffix(3))")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 47)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.vertical, 10)
                    .listRowBackground(currencyPairs[index].selected ? Color.yellow : Color.clear)
                    .onTapGesture {
                        updateDatabaseCurrencyPairModel(model: currencyPairs[index])
                    }
                }
            }
            .background(Color("CurrencyPairListRowColor"))
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .navigationTitle("favoriteCurrencyPairListTitle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowCurrencyPairListView = true
                    }label: {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowCurrencyPairListView, content: {
                CurrencyPairListView()
            })
        }
    }
    func updateDatabaseCurrencyPairModel(model: DatabaseCurrencyPairModel) {
        let manager = DatabaseManager(modelContext: modelContext)
        do {
            try manager.updateSelected(name: model.pairName)
        } catch  {
            print(error)
        }
    }

    func attributedString(for text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        // 末尾3文字から末尾の1文字を除いた範囲を取得
        let length = text.count
        if length >= 3 {
            let startIndex = text.index(text.endIndex, offsetBy: -3) // 最後から3文字目の開始位置
            let endIndex = text.index(text.endIndex, offsetBy: -1)   // 最後の1文字を除く
            let range = NSRange(startIndex..<endIndex, in: text)
            
            if let rangeInAttributedString = Range(range, in: attributedString) {
                attributedString[rangeInAttributedString].font = .system(size: 25, weight: .bold) // フォントサイズを指定
            }
        }
        return attributedString
    }
    func attributedXAUString(for text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        // 末尾の2文字に対して範囲を指定してスタイルを変更
        if let range = attributedString.range(of: String(text.suffix(2))) {
            attributedString[range].font = .system(size: 25, weight: .bold) // フォントサイズを指定
        }
        return attributedString
    }
}

#Preview {
    FavotiteCurrencyPairListView()
}
