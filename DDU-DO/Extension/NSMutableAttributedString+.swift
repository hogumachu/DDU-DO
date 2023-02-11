//
//  NSMutableAttributedString+.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/11.
//

import UIKit
import Then

extension NSMutableAttributedString {
    
    func paragraphStyle(
        lineHeight: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil
    ) -> NSMutableAttributedString {
        let paragrahStyle = NSMutableParagraphStyle().with {
            if let lineHeight = lineHeight {
                $0.maximumLineHeight = lineHeight
                $0.minimumLineHeight = lineHeight
            }
            
            if let paragraphSpacing = paragraphSpacing {
                $0.paragraphSpacing = paragraphSpacing
            }
        }
        let range = NSRange(location: 0, length: self.length)
        self.addAttributes([.paragraphStyle: paragrahStyle], range: range)
        return self
    }
    
    func verticalCenter(lineHeight: CGFloat, font: UIFont) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: self.length)
        self.addAttributes([.baselineOffset: (lineHeight - font.lineHeight) / 4], range: range)
        return self
    }
    
}
