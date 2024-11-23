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

    init(){
        print("HomeTabView")
    }
    
    var body: some View {
        GeometryReader { GeometryProxy in
            NavigationStack {
                VStack(spacing: 0) {
                    
                    HomeTabBarView(selected: $selected,
                                   isDisabled: $isDisabled,
                                   height: GeometryProxy.size.height)
                    
                    TabView(selection: $selected) {
                        LotCalculatorView(isShowCurrencyPairListView: $isShowCurrencyPairListView)
                            .tag(0)
                        
                        RiskRewardView()
                            .tag(1)
                    }
                    .onChange(of: selected) {
                        if keyboardObserver.isKeyboardVisible {
                            hideKeyboard()
                        }
                    }
                    .onAppear {
                        keyboardObserver.startObserving()
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
                .navigationDestination(isPresented: $isShowCurrencyPairListView, destination: {
                    FavotiteCurrencyPairListView()
                })
            }
        }
    }
}

#Preview {
    HomeTabView()
}
