//
//  AppComponent.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs

final class AppComponent: Component<EmptyDependency>, AppRootDependency {
  
  init() {
    super.init(dependency: EmptyComponent())
  }
  
}
