//
//  CurrencyPairListView.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/28.
//

import SwiftUI
import SwiftData


struct FavotiteCurrencyPairListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate { $0.favorited == true },
        sort: \DatabaseCurrencyPairModel.pairName,
        order: .forward
    ) private var currencyPairs: [DatabaseCurrencyPairModel]
    
    @State private var isShowCurrencyPairListView = false
    @Binding var isPurchased: Bool
    
    var body: some View {
        NavigationStack {
            CurrencyPairListContent(
                currencyPairs: currencyPairs,
                onUpdateModel: updateDatabaseCurrencyPairModel
            )
            .background(Color("CurrencyPairListRowColor"))
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .navigationTitle("favoriteCurrencyPairListTitle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowCurrencyPairListView = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowCurrencyPairListView) {
                CurrencyPairListView(isPurchased: $isPurchased)
            }
        }
    }
    
    func updateDatabaseCurrencyPairModel(model: DatabaseCurrencyPairModel) {
        let manager = DatabaseManager(modelContext: modelContext)
        do {
            try manager.updateSelected(name: model.pairName)
        } catch {
            print(error)
        }
    }
    
    func attributedString(for text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        let length = text.count
        if length >= 3 {
            let startIndex = text.index(text.endIndex, offsetBy: -3)
            let endIndex = text.index(text.endIndex, offsetBy: -1)
            let range = NSRange(startIndex..<endIndex, in: text)
            
            if let rangeInAttributedString = Range(range, in: attributedString) {
                attributedString[rangeInAttributedString].font = .system(size: 25, weight: .bold)
            }
        }
        return attributedString
    }
    
    func attributedXAUString(for text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        if let range = attributedString.range(of: String(text.suffix(2))) {
            attributedString[range].font = .system(size: 25, weight: .bold)
        }
        return attributedString
    }
}

// リストの内容を表示するビュー
struct CurrencyPairListContent: View {
    let currencyPairs: [DatabaseCurrencyPairModel]
    let onUpdateModel: (DatabaseCurrencyPairModel) -> Void
    
    var body: some View {
        List {
            ForEach(currencyPairs, id: \.pairName) { currencyPair in
                CurrencyPairRow(
                    currencyPair: currencyPair,
                    onTap: { onUpdateModel(currencyPair) }
                )
            }
        }
        .background(Color("CurrencyPairListRowColor"))
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .navigationTitle("favoriteCurrencyPairListTitle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 各行のビュー
struct CurrencyPairRow: View {
    let currencyPair: DatabaseCurrencyPairModel
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            RateDisplay(currencyPair: currencyPair)
            CurrencyPairSymbols(pairName: currencyPair.pairName)
        }
        .padding(.vertical, 10)
        .listRowBackground(currencyPair.selected ? Color.yellow : Color.clear)
        .onTapGesture(perform: onTap)
    }
}

// レート表示部分
struct RateDisplay: View {
    let currencyPair: DatabaseCurrencyPairModel
    
    var body: some View {
        HStack {
            Text(currencyPair.pairName)
                .fontWeight(.bold)
                .monospaced()
            Spacer()
            if(currencyPair.pairName.prefix(3) != "XAU") {
                Text(attributedString(for: String(format: currencyPair.pairName.suffix(3) == "JPY" ? "%.3f" : "%.5f", currencyPair.pairRate)))
                    .monospacedDigit()
            } else {
                Text(attributedXAUString(for: String(format: "%.2f", currencyPair.pairRate)))
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
    
    // 属性付き文字列のヘルパー関数
    func attributedString(for text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        let length = text.count
        if length >= 3 {
            let startIndex = text.index(text.endIndex, offsetBy: -3)
            let endIndex = text.index(text.endIndex, offsetBy: -1)
            let range = NSRange(startIndex..<endIndex, in: text)
            
            if let rangeInAttributedString = Range(range, in: attributedString) {
                attributedString[rangeInAttributedString].font = .system(size: 25, weight: .bold)
            }
        }
        return attributedString
    }
    
    func attributedXAUString(for text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        if let range = attributedString.range(of: String(text.suffix(2))) {
            attributedString[range].font = .system(size: 25, weight: .bold)
        }
        return attributedString
    }
}

// 通貨ペアのシンボル表示部分
struct CurrencyPairSymbols: View {
    let pairName: String
    
    var body: some View {
        HStack {
            Image("\(pairName.prefix(3))")
                .resizable()
                .scaledToFit()
                .frame(width: 47)
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .clipShape(Circle())
            Text("/")
                .font(.title)
            Image("\(pairName.suffix(3))")
                .resizable()
                .scaledToFit()
                .frame(width: 47)
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .clipShape(Circle())
        }
    }
}

#Preview {
    FavotiteCurrencyPairListView(isPurchased: .constant(false))
}
