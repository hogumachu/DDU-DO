//
//  TodoDetailViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/22.
//

import RIBs
import RxSwift
import UIKit

protocol TodoDetailPresentableListener: AnyObject {
    func textUpdated(_ text: String)
    func didTapConfirm()
}

final class TodoDetailViewController: UIViewController, TodoDetailPresentable, TodoDetailViewControllable {

    weak var listener: TodoDetailPresentableListener?
}
