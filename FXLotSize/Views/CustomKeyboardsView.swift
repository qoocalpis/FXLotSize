//
//  ScrollPickerView.swift
//  FXLotSize
//
//  Created by primagest on 2024/12/07.
//


import SwiftUI


import SwiftUI

struct CustomKeyboardsView: View {
    
    @Binding var riskString: String
    @Binding var rewardString: String
    let zero = "0"
    
    var body: some View {
        
        GeometryReader { geometry in
            let ButtonWidth = geometry.size.width / 7.5
            let width = geometry.size.width / 2.5
            VStack {
                Spacer()
                HStack {
                    VStack {
                        Text("risk")
                        Text("\(riskString)")
                            .font(.title)
                            .frame(width: width)
                    }
                    VStack {
                        Text("reward")
                        Text("\(rewardString)")
                            .font(.title)
                            .frame(width: width)
                    }
                }
                .padding()
                .padding(.bottom)
                
                HStack {
                    // カスタムキーボード1
                    VStack {
                        ForEach(1...3, id: \.self) { row in
                            HStack {
                                ForEach(1...3, id: \.self) { col in
                                    let number = (row - 1) * 3 + col
                                    Button(action: {
                                        if(riskString == zero) {
                                            riskString = "\(number)"
                                        }else {
                                            riskString.append("\(number)")
                                        }
                                    }) {
                                        Text("\(number)")
                                            .frame(width: ButtonWidth, height: ButtonWidth)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                    }
                                }
                            }
                        }
                        HStack {
                            Button(action: {
                                if(riskString.count == 1) {
                                    riskString = zero
                                }else {
                                    riskString.removeLast()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .frame(width: ButtonWidth, height: ButtonWidth)
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(5)
                            }
                            Button(action: {
                                if(riskString != zero) {
                                    riskString.append(zero)
                                }
                            }) {
                                Text(zero)
                                    .frame(width: ButtonWidth, height: ButtonWidth)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            Button(action: {
                                riskString = zero
                            }) {
                                Text("AC")
                                    .frame(width: ButtonWidth, height: ButtonWidth)
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // カスタムキーボード2
                    VStack {
                        ForEach(1...3, id: \.self) { row in
                            HStack {
                                ForEach(1...3, id: \.self) { col in
                                    let number = (row - 1) * 3 + col
                                    Button(action: {
                                        if(rewardString == zero) {
                                            rewardString = "\(number)"
                                        }else {
                                            rewardString.append("\(number)")
                                        }
                                    }) {
                                        Text("\(number)")
                                            .frame(width: ButtonWidth, height: ButtonWidth)
                                        
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                    }
                                }
                            }
                        }
                        HStack {
                            Button(action: {
                                if(rewardString.count == 1) {
                                    rewardString = zero
                                }else {
                                    rewardString.removeLast()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .frame(width: ButtonWidth, height: ButtonWidth)
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(5)
                            }
                            Button(action: {
                                if(rewardString != zero) {
                                    rewardString.append(zero)
                                }
                            }) {
                                Text(zero)
                                    .frame(width: ButtonWidth, height: ButtonWidth)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            Button(action: {
                                rewardString = zero
                            }) {
                                Text("AC")
                                    .frame(width: ButtonWidth, height: ButtonWidth)
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            .padding()
            .onChange(of: riskString) { oldValue, newValue in
                if(oldValue.count == 4 && newValue.count == 5) {
                    riskString = "9999"
                }
            }
            .onChange(of: rewardString) { oldValue, newValue in
                if(oldValue.count == 4 && newValue.count == 5) {
                    rewardString = "9999"
                }
            }
        }
    }
}


//
//#Preview {
//    CustomKeyboardsView(riskString: <#Binding<String>#>, rewardString: <#Binding<String>#>)
//}
