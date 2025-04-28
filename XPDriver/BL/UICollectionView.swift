//
//  UICollectionView.swift
//  XPDriver
//
//  Created by Waseem  on 29/10/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register(_ cellsName : String)
    {
        self.register(UINib.init(nibName: cellsName, bundle: nil), forCellWithReuseIdentifier: cellsName)
    }
    
    func register(_ cellsNames : [String])
    {
        cellsNames.forEach { self.register($0) }
    }
    
    func cell<T>(for index: IndexPath) -> T where T: UICollectionViewCell {
        if let dict = value(forKey: "_cellNibDict") as? [String: UINib],dict.keys.contains(String(describing: T.self)) { } else {
            register(String(describing: T.self))
        }
       return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: index) as! T
    }
    
    func numberOfItems() -> Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfItems(inSection: section)
            section += 1
        }
        return rowCount
    }
    
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard section >= 0 else { return nil }
        guard numberOfItems(inSection: section) > 0  else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfItems(inSection: section) - 1, section: section)
    }
    
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    func indexPathForView(_ view: UIView) -> IndexPath? {
        return self.indexPathForItem(at: view.convert(CGPoint.zero, to:self))
    }
}

