//
//  UIColor+.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/13.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        guard hexString.count == 6 else { return nil }
        var hexNumber: UInt64 = 0
        let scanner = Scanner(string: hexString)
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        let r, g, b: CGFloat
        r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        b = CGFloat(hexNumber & 0x000000ff) / 255
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
