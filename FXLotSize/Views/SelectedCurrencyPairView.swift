//
//  SelectedCurrencyPairView.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/07.
//

import SwiftUI
import SwiftData

struct SelectedCurrencyPairView: View {
    
    let currencyPairs: [DatabaseCurrencyPairModel]
    @Binding var isShowCurrencyPairListView: Bool
//    init(isShowFavoriteCurrencyPairListView: Bool) {
//        // 特定のcurrencyCodeに一致するクエリを作成
//        _currencyPairs = Query(filter: #Predicate { $0.selected == true })
//        _isShowFavoriteCurrencyPairListView = .constant(isShowFavoriteCurrencyPairListView)
//    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            let width = geometryProxy.size.width
            //            let height = geometryProxy.size.height
            ZStack{
                Color("CurrentSelectedCurrencyPairBackGroundColor")
                VStack(spacing: 10) {
                    
                    // 最初の要素を取得
                    if let selectedCurrencyPair = currencyPairs.first {
                        Text(selectedCurrencyPair.pairName)
                            .font(.title)
                            .foregroundStyle(Color.black)
                            .italic()
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    } else {
                        Text("JPY/JPY")
                            .foregroundStyle(Color.black)
                    }
                    
                    HStack(spacing: 0) {
                        
                        Text("rate")
                            .frame(width: width / 3)
                            .foregroundStyle(Color.black)
                        
                        // 最初の要素を取得
                        if let selectedCurrencyPair = currencyPairs.first {
                            if(selectedCurrencyPair.pairName.prefix(3) != "XAU"){
                                Text(String(format: selectedCurrencyPair.pairName.suffix(3) == "JPY" ? "%.3f" : "%.5f",selectedCurrencyPair.pairRate))
                                    .bold()
                                    .font(.title2)
                                    .frame(width: width / 3)
                                    .foregroundStyle(Color.black)
                            }else {
                                Text(String(format: "%.2f",selectedCurrencyPair.pairRate))
                                    .bold()
                                    .font(.title2)
                                    .frame(width: width / 3)
                                    .foregroundStyle(Color.black)
                            }
                        } else {
                            Text("199.000")
                                .foregroundStyle(Color.black)
                        }
                        
                        Button(action: {
                            isShowCurrencyPairListView.toggle()
                        }){
                            Label("MyList", systemImage: "list.bullet.rectangle.fill")
                                .padding(7)
                                .foregroundColor(.blue)
                                .bold()
                                .background(.green)
                                .cornerRadius(5)
                                .shadow(color: Color.black, radius: 2, x: 0, y: 1)
                        }
                        .frame(width: width / 3)
                    }
                }
            }
            .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 20,
                                              bottomTrailingRadius: 20))
        }
    }
    func formattedPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0 // 小数点以下0桁を許容
        formatter.maximumFractionDigits = 5 // 小数点以下最大5桁まで表示
        formatter.numberStyle = .decimal // 小数点を含む数値形式
        
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}

#Preview {
    HomeTabView()
}
