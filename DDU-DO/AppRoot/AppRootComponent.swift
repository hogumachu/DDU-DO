//
//  AppRootComponent.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs
import RealmSwift

final class AppRootComponent: Component<AppRootDependency>, HomeDependency, SettingDependency, CalendarDependency, RecordDependency, TodoDetailDependency {
    var todoUseCase: TodoUseCase = DefaultTodoUseCase(repository: RealmTodoRepository(realm: try! Realm()))
    let calculator: CalendarCalculator = CalendarCalculator()
    lazy var settingBuildable: SettingBuildable = SettingBuilder(dependency: self)
    lazy var recordBuildable: RecordBuildable = RecordBuilder(dependency: self)
    lazy var todoDetailBuidable: TodoDetailBuildable = TodoDetailBuilder(dependency: self)
}
