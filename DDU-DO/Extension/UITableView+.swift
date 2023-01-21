//
//  UITableView+.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/21.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(cell: T.Type) {
        self.register(cell, forCellReuseIdentifier: String(describing: cell))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: String(describing: cell), for: indexPath) as? T
    }
    
    func scrollToBottom() {
        let lastSectionIndex = self.numberOfSections - 1
        if lastSectionIndex < 0 { return }
        
        let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1
        if lastRowIndex < 0 {  return }
        
        let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        self.scrollToRow(at: pathToLastRow, at: .bottom, animated: true)
    }
    
}
