//
//  SceneDelegate.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/03.
//

import UIKit
import RIBs

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var router: LaunchRouting?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let component = AppComponent()
        let router = AppRootBuilder(dependency: component).build()
        self.router = router
        router.launch(from: window)
    }
    
}

