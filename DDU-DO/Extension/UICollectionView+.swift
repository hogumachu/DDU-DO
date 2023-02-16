//
//  UICollectionView+.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/21.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(cell: T.Type) {
        self.register(cell, forCellWithReuseIdentifier: String(describing: cell))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as? T
    }
    
    func registerReusableView<T: UICollectionReusableView>(view: T.Type) {
        let identifier = String(describing: view)
        self.register(
            view,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identifier
        )
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(view: T.Type, for indexPath: IndexPath) -> T? {
        let identifier = String(describing: view)
        return self.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T
    }
    
}
