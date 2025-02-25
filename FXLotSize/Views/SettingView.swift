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
    
    @Environment(\.colorScheme) var colorScheme
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
    @ObservedObject var storeKitManager: StoreKitManager
    @State var isPurchased: Bool = false
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            NavigationView {
                VStack {
                    ScrollView {
                        VStack(spacing: 10) {
                            PickerSettingsView(
                                selectedCurrency: $selectedCurrency,
                                selectedOneLotSize: $selectedOneLotSize,
                                selectedLossAllowance: $selectedLossAllowance
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
                            
                            ProductVersionView(
                                storeKitManager: storeKitManager,
                                isPurchased: $isPurchased,
                                width: width,
                                colorScheme: colorScheme
                            )
                            restoreButton
                        }
                        .padding()
                    }
                }
                .onAppear() {
                    Task {
                        isPurchased = (try? await storeKitManager.isPurchased(productId: storeKitManager.proVersionProductID)) ?? false
                    }
                }
                .onChange(of: storeKitManager.purchasedCourses, { oldValue, newValue in
                    Task {
                        isPurchased = (try? await storeKitManager.isPurchased(productId: storeKitManager.proVersionProductID)) ?? false
                    }
                })
                .onAppear {
                    if let firstUser = users.first {
                        selectedCurrency = firstUser.currency
                        selectedOneLotSize = String(firstUser.oneLotSize)
                        selectedLossAllowance = String(firstUser.lossPercent)
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
                    CurrencyPairListView(isPurchased: $isPurchased)
                })
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func updateUser() async {
        let manager = DatabaseManager(modelContext: modelContext)
        do {
            try await manager.updateUserModel(
                currency: selectedCurrency,
                lossPercent: Int(selectedLossAllowance)!,
                oneLotSize: Int(selectedOneLotSize)!
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
    SettingView(storeKitManager: StoreKitManager())
}
