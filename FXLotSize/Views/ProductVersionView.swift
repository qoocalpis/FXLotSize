//
//  ProductVersionView.swift
//  FXLotSize
//
//  Created by primagest on 2025/02/09.
//

import SwiftUI
import StoreKit

// 製品バージョン表示用のView
struct ProductVersionView: View {
    @ObservedObject var storeKitManager: StoreKitManager
    @Binding var isPurchased: Bool
    let width: CGFloat
    let colorScheme: ColorScheme
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        ForEach(storeKitManager.storeProducts) { product in
            if(product.id == storeKitManager.proVersionProductID) {
                ProductVersionContent(
                    product: product,
                    storeKitManager: storeKitManager,
                    isPurchased: isPurchased,
                    width: width,
                    colorScheme: colorScheme,
                    contentHeight: $contentHeight
                )
            }
        }
    }
}

// 製品バージョンの内容表示用のView
struct ProductVersionContent: View {

    let product: Product
    let storeKitManager: StoreKitManager
    let isPurchased: Bool
    let width: CGFloat
    let colorScheme: ColorScheme
    @Binding var contentHeight: CGFloat
    
    var body: some View {
        let foregroundColor = Color(colorScheme == .dark ? .white : .black)

        VStack {
            HStack {
                Text("CurrentProductVersion")
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom)
            HStack {
                ZStack {
                    Color(isPurchased ? Color.clear : Color.green)
                        .opacity(isPurchased ? 0 : 0.2)
                    Text("free")
                        .font(.headline)
                }
                .frame(width: width * 0.4)
                .frame(height: contentHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isPurchased ? Color.clear : Color.green, lineWidth: 2)
                )
                
                Spacer()
                ZStack {
                    Color(isPurchased ? Color.green : Color.clear)
                        .opacity(isPurchased ? 0.2 : 0)
                    Button {
                        Task { try await storeKitManager.purchase(product) }
                    } label: {
                        VStack {
                            Text("Pro+")
                                .font(.headline)
                                .foregroundStyle(foregroundColor)
                                .padding(.bottom, 5)
                            VStack(alignment: .leading) {
                                Text("AllCurrencyPairsAvailable")
                                    .font(.caption2)
                                    .foregroundColor(foregroundColor)
                                Text("AbilityToChangeFundRatio")
                                    .font(.caption2)
                                    .foregroundColor(foregroundColor)
                            }
                        }
                        .padding()
                    }
                }
                .frame(width: width * 0.4)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isPurchased ? Color.green : Color.clear, lineWidth: 2)
                )
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            contentHeight = geometry.size.height
                        }
                    }
                )
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}
