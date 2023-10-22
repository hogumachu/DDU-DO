//
//  RecordViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/22.
//

import RIBs
import RxSwift
import UIKit

protocol RecordPresentableListener: AnyObject {
    func textUpdated(_ text: String)
    func didTapConfirm()
}

final class RecordViewController: UIViewController, RecordPresentable, RecordViewControllable {

    weak var listener: RecordPresentableListener?
}
