//
//  FirstLoadingRateView.swift
//  FX_LotSize
//
//  Created by user1 on 2024/04/20.
//

import SwiftUI
import SwiftData

struct FirstLoadingRateView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State var isUpdated = false
    
    var body: some View {
        ZStack {
            Color("FirstLoadingPageBackGroundColor")
            
            VStack {
                // ラベルやアクセントカラーなどを指定してカスタマイズできる
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
                    .tint(Color.orange)
                
                Text("loading Rate")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(20)
            }
        }
        .ignoresSafeArea()
        .onAppear(){
            Task {
                await SetUser()
            }
        }
        .fullScreenCover(isPresented: $isUpdated) {
            HomeTabView()
        }
    }
    
    private func SetUser() async {
        let manager = DatabaseManager(modelContext: modelContext)
        do {
            isUpdated = try await manager.setFirstInsert()
        } catch  {
            print(error)
        }
    }
}

#Preview {
    FirstLoadingRateView()
}
