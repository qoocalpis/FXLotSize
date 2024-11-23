//
//  HomeTabBarView.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/07.
//

import SwiftUI


struct HomeTabBarView: View {
    @Binding var selected: Int
    @Binding var isDisabled: Bool
    let height: Double
    
    var body: some View {
        VStack{
            if(selected == 0){
                Text("lotSizeCalculatorTitle")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            if(selected == 1){
                Text("riskRewardRatioTitle")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            HStack {
                HomeTabBarButtonView(
                    selected: $selected,
                    isDisabled: $isDisabled,
                    image: Image("CalculatorIcon"),
                    color: Color(red: 0.3, green: 0.5, blue: 0.2),
                    tag: 0
                )
                
                HomeTabBarButtonView(
                    selected: $selected,
                    isDisabled: $isDisabled,
                    image: Image("RiskRewardRatioIcon"),
                    color: Color.orange,
                    tag: 1
                )
            }
        }
        .frame(height: height * 0.1)
        .background(Color("HomeTabBarBackGroundColor"))
    }
}

struct HomeTabBarButtonView: View {
    @Binding var selected: Int
    @Binding var isDisabled: Bool
    var image: Image
    var color: Color
    var tag: Int
    
    var body: some View {
        
        Button {
            if !isDisabled {
                selected = tag
            }
        } label: {
            VStack(spacing: 0) {
                ZStack{
                    image
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.white)
                        .opacity(selected != tag ? 0.3 : 1)
                }
                Rectangle()
                    .fill(color)
                    .frame(height: 6)
                    .opacity(selected != tag ? 0 : 1)
            }
        }
    }
}

#Preview() {
    HomeTabBarView(selected: .constant(0),
                   isDisabled: .constant(false),
                   height: 80)
}

