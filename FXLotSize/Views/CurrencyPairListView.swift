//
//  CurrencyPairListView.swift
//  FXLotSize
//
//  Created by primagest on 2024/11/07.
//

import SwiftUI
import SwiftData


struct CurrencyPairListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DatabaseCurrencyPairModel.pairName,
           order: .forward
    ) private var currencyPairs: [DatabaseCurrencyPairModel]
    @Query private var users: [DatabaseUserModel]
    @Binding var isPurchased: Bool
    let array = ["USD/JPY", "EUR/USD", "GBP/JPY"]

    var body: some View {
        NavigationStack {
            List {
                if(!isPurchased) {
                    Section {
                        ForEach(0..<currencyPairs.count, id: \.self) { index in
                            if(array.contains(currencyPairs[index].pairName)) {
                                Row(model: currencyPairs[index])
                                    .onTapGesture {
                                        updateDatabaseCurrencyPairModel(model: currencyPairs[index])
                                    }
                            }
                        }
                    } header: {
                        Text("free")
                    }
                }
                Section {
                    ForEach(0..<currencyPairs.count, id: \.self) { index in
                        Row(model: currencyPairs[index])
                            .opacity(isPurchased ? 1.0 : 0.5)
                            .onTapGesture {
                                if(isPurchased){
                                    updateDatabaseCurrencyPairModel(model: currencyPairs[index])
                                }
                            }
                    }
                } header: {
                    Text("Pro+")
                }
            }
            .navigationTitle("currencyPairListTitle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }
                }
            }
        }
    }
    func updateDatabaseCurrencyPairModel(model: DatabaseCurrencyPairModel) {
        let manager = DatabaseManager(modelContext: modelContext)
        do {
            try manager.updatefavorited(name: model.pairName)
        } catch  {
            print(error)
        }
    }
}

struct Row: View {
    let model: DatabaseCurrencyPairModel
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .font(.title3)
                .foregroundStyle(Color.yellow)
                .opacity(model.favorited ? 1 : 0)
            VStack(alignment: .leading) {
                Text(model.pairName)
                Text(model.pairFullName)
                    .font(.caption2)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}


#Preview {
    CurrencyPairListView(isPurchased: .constant(false))
}
