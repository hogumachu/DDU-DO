//
//  ToastManager.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/31.
//

import UIKit
import Then

enum ToastManager {
    
    static func showToast(_ model: ToastModel) {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let height: CGFloat = 35
        let viewSize = keyWindow.bounds.size
        let topSafeArea = UIScreen.topSafeAreaInset
        let toast = Toast(frame: CGRect(x: 20, y: topSafeArea, width: viewSize.width - 40, height: height))
        toast.alpha = 0
        toast.configure(model)
        keyWindow.addSubview(toast)
        keyWindow.bringSubviewToFront(toast)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            toast.alpha = 1
            toast.frame.origin = CGPoint(x: 20, y: topSafeArea + height)
        } completion: { _ in
            ToastCenter.shared.addToast(toast)
        }
    }
    
    static func hideToast(_ toast: Toast) {
        let toastOrigin = toast.frame.origin
        let topSafeArea = UIScreen.topSafeAreaInset
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
            toast.alpha = 0
            toast.frame.origin = CGPoint(x: toastOrigin.x, y: topSafeArea)
        } completion: { _ in
            toast.removeFromSuperview()
        }
    }
    
}
