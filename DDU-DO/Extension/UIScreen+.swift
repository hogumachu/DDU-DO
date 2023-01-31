//
//  UIScreen+.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/31.
//

import UIKit

extension UIScreen {
    
    static var safeAreaInsets: UIEdgeInsets? {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets
    }
    
    static var topSafeAreaInset: CGFloat {
        UIScreen.safeAreaInsets?.top ?? 0
    }
    
}
