//
//  UIDevice.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/16.
//

import UIKit

extension UIDevice {
    
    var modelName: String {
        var utsname = utsname()
        uname(&utsname)
        let mirror = Mirror(reflecting: utsname.machine)
        let id = mirror.children.reduce("") { id, element in
            guard let value = element.value as? Int8, value != 0 else { return id }
            return id + String(UnicodeScalar(UInt8(value)))
        }
        return id
    }
    
}
