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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(currencyPairs, id: \.pairName) { currencyPair in
                    ZStack {
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
                        
                        HStack {
                            Image("\(currencyPair.pairName.prefix(3))")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 47)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                .clipShape(Circle())
                            Text("/")
                                .font(.title)
                            Image("\(currencyPair.pairName.suffix(3))")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 47)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.vertical, 10)
                    .listRowBackground(currencyPair.selected ? Color.yellow : Color.clear)
                    .onTapGesture {
                        updateDatabaseCurrencyPairModel(model: currencyPair)
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
                CurrencyPairListView()
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
#Preview {
    FavotiteCurrencyPairListView()
}
