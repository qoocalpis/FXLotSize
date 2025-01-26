//
//  SettingView.swift
//  FXLotSize
//
//  Created by primagest on 2024/12/30.
//

import SwiftUI
import SwiftData
import StoreKit

struct SettingView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [DatabaseUserModel]
//    @StateObject private var userModel = UserModel() // UserModelをObservableObjectとして定義
    @State private var isShowCurrencyPairListView = false
    @State private var showPaywall = false
    @State private var showRestoreAlert = false
    @State private var selectedCurrency: String = "USD" // デフォルト値を設定
    @State private var selectedOneLotSize: String = "10000" // デフォルト値を設定
    @State private var selectedLossAllowance: String = "2" // デフォルト値を設定
    @State private var selectedProductVersion: String = "" // デフォルト値を設定
    @StateObject private var storeKitManager = StoreKitManager()
    @State var isPurchased: Bool = false
    // 表示したい特定の Product ID
    private let proVersionProductID = "com.yuki.FXLotSize.Pro"
    private let pro = "Pro"
    private let free = "Free"
    let currencies = ["USD", "JPY"] // Pickerの選択肢
    let constractSizes = [
        "1000",
        "5000",
        "10000",
        "50000",
        "100000",
    ]
    let percentList: [String] = (1...100).map { String($0) }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 10) {
                        SettingCell(
                            titleText: Text("AccountCurrency"),
                            items: currencies,
                            text: $selectedCurrency
                        )
                        SettingCell(
                            titleText: Text("OneLotSize"),
                            items: constractSizes,
                            text: $selectedOneLotSize
                        )
                        SettingCell(
                            titleText: Text("FixedProfitAndLossAllowance"),
                            items: percentList,
                            text: $selectedLossAllowance
                        )
                        HStack {
                            Text("currencyPairListTitle")
                                .font(.headline)
                            Spacer()
                            Button {
                                isShowCurrencyPairListView = true
                            } label: {
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.green)
                                    .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)

                        ForEach(storeKitManager.storeProducts) { product in
                            if(product.id == proVersionProductID){
                                HStack {
                                    Text("CurrentProductVersion")
                                        .font(.headline)
                                    
                                    Spacer()
                                    Button {
                                        Task { try await storeKitManager.purchase(product) }
                                    } label: {
                                        Text(selectedProductVersion)
                                            .font(.headline)
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                        restoreButton
                    }
                    .padding()
                }
            }
            .onChange(of: storeKitManager.purchasedCourses, { oldValue, newValue in
                Task {
                    isPurchased = (try? await storeKitManager.isPurchased(productId: proVersionProductID)) ?? false
                    await updateUser()
                }
            })
            .onChange(of: isPurchased, { oldValue, newValue in
                selectedProductVersion = newValue ? pro : free
            })
            .onAppear {
                if let firstUser = users.first {
                    selectedCurrency = firstUser.currency
                    selectedOneLotSize = String(firstUser.oneLotSize)
                    selectedLossAllowance = String(firstUser.lossPercent)
                    selectedProductVersion = firstUser.purchased ? pro : free
                }
            }
            .onChange(of: selectedCurrency, { oldValue, newValue in
                Task { await updateUser() }
            })
            .onChange(of: selectedOneLotSize, { oldValue, newValue in
                Task { await updateUser() }
            })
            .onChange(of: selectedLossAllowance, { oldValue, newValue in
                Task { await updateUser() }
            })
            .fullScreenCover(isPresented: $isShowCurrencyPairListView, content: {
                CurrencyPairListView()
            })
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func updateUser() async {
        let manager = DatabaseManager(modelContext: modelContext)
        do {
            try await manager.updateUserModel(
                currency: selectedCurrency,
                lossPercent: Int(selectedLossAllowance)!,
                oneLotSize: Int(selectedOneLotSize)!,
                purchased: isPurchased
            )
        } catch  {
            print(error)
        }
    }
    
    private var restoreButton: some View {
        Button(action: {
            Task {
                //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                //Call this function only in response to an explicit user action, such as tapping a button.
                try? await AppStore.sync()
            }
        }) {
            Text("Restore Purchase item and condition >")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    SettingView()
}
