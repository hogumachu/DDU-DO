//
//  AppBundle.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/16.
//

import Foundation

enum AppBundle {
    
    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
}
