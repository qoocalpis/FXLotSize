//
//  KeyboardObserver.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/25.
//

import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    func startObserving() {
        // キーボードが表示されたときの通知を受け取る
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in
                self?.isKeyboardVisible = true
            }
            .store(in: &cancellables)
        
        // キーボードが非表示になったときの通知を受け取る
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.isKeyboardVisible = false
            }
            .store(in: &cancellables)
    }
    
    func stopObserving() {
        cancellables.removeAll()
    }
}
