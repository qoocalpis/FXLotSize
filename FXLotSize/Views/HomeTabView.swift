//
//  HomeTabView.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/07.
//


import SwiftUI


struct HomeTabView: View {
        
    @State var selected = 0
    @State var isDisabled = false
//    @StateObject var storeKit = StoreKitManager()
    @StateObject private var keyboardObserver = KeyboardObserver()
    @State private var isShowCurrencyPairListView: Bool = false
    @State private var isShowSettingView: Bool = false
    @State private var isPurchased: Bool = false
    @StateObject private var storeKitManager = StoreKitManager()
    
    var body: some View {
        GeometryReader { GeometryProxy in
            NavigationStack {
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        HomeTabBarView(selected: $selected,
                                       isDisabled: $isDisabled,
                                       height: GeometryProxy.size.height)
                        Button {
                            isShowSettingView = true
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .padding(.horizontal,10)
                                .foregroundStyle(Color.green)
                        }
                    }
                    TabView(selection: $selected) {
                        LotCalculatorView(isShowCurrencyPairListView: $isShowCurrencyPairListView)
                            .tag(0)
                        
                        RiskRewardView(isPurchased: $isPurchased)
                            .tag(1)
                    }
                    .onChange(of: selected) {
                        if keyboardObserver.isKeyboardVisible {
                            hideKeyboard()
                        }
                    }
                    .onAppear {
                        keyboardObserver.startObserving()
                        Task {
                            isPurchased = (try? await storeKitManager.isPurchased(productId: storeKitManager.proVersionProductID)) ?? false
                        }
                    }
                    .onDisappear {
                        keyboardObserver.stopObserving()
                    }
                    // スワイプアクションを有効化
                    .disabled(false)
                    // ページスタイル（インジケータ非表示）
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    // 切り替え時のアニメーション
                    .animation(.easeInOut, value: selected)
                }
                .fullScreenCover(isPresented: $isShowCurrencyPairListView, content: {
                    FavotiteCurrencyPairListView(isPurchased: $isPurchased)
                })
                .navigationDestination(isPresented: $isShowSettingView, destination: {
                    SettingView(storeKitManager: storeKitManager)
                })
            }
        }
    }
}

#Preview {
    HomeTabView()
}
