//
//  View.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/25.
//

import SwiftUI

// キーボードを閉じるメソッド
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
