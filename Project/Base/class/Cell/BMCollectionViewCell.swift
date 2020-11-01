//
//  BMCollectionViewCell.swift
//  Project
//
//  Created by Be More on 11/1/20.
//

import UIKit

class BMCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties.
    
    /// get the collection view own the cell.
    var collectionView: UICollectionView? {
        return self.next(of: UICollectionView.self)
    }

    /// get the index path of the given cell.
    var indexPath: IndexPath? {
        return self.collectionView?.indexPath(for: self)
    }
    
    // MARK: - Lifecycles.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    
    // MARK: - Helpers.
    
    private static func nibName() -> String {
        return String(describing: self.self)
    }
    
    static func registerCellByNib(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: self.nibName(), bundle: nil), forCellWithReuseIdentifier: self.nibName())
    }
    
    static func registerCellByClass(collectionView: UICollectionView) {
        collectionView.register(self.self, forCellWithReuseIdentifier: self.nibName())
    }
    
    static func loadCell(collectionView: UICollectionView, indexPath: IndexPath) -> BMCollectionViewCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.nibName(), for: indexPath) as? BMCollectionViewCell else {
            return BMCollectionViewCell()
        }
        return cell
    }
    
}

