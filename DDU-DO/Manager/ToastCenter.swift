//
//  ToastCenter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/31.
//

import Foundation

final class ToastCenter {
    
    static let shared = ToastCenter()
    
    private init() {}
    
    func addToast(_ toast: Toast) {
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] timer in
            guard let self = self else { return }
            ToastManager.hideToast(toast)
            self.removeToast(toast)
        }
        self.toastTimers[toast] = timer
    }
    
    func removeToast(_ toast: Toast) {
        self.toastTimers.removeValue(forKey: toast)
    }
    
    private var toastTimers: [Toast: Timer] = [:]
}
