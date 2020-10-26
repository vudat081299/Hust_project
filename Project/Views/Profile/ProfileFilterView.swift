//
//  ProfileFilterView.swift
//  Project
//
//  Created by Be More on 10/16/20.
//

import UIKit

private let cellIden = "ProfileFilterCell"

protocol ProfileFilterViewDelegate: class {
    func filterView(_ filterView: ProfileFilterView, didSelectItemAt indexPath: IndexPath)
}

class ProfileFilterView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ProfileFilterViewDelegate?
    
    lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collecionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecionView.backgroundColor = .white
        collecionView.delegate = self
        collecionView.dataSource = self
        collecionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: cellIden)
        return collecionView
    }()
    
    private lazy var underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.filterCollectionView)
        self.filterCollectionView.addConstraintsToFillView(self)
        
        let selectIndex = IndexPath(item: 0, section: 0)
        self.filterCollectionView.selectItem(at: selectIndex, animated: true, scrollPosition: .left)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(self.underLineView)
        underLineView.anchor(left: self.leftAnchor,
                             bottom: self.bottomAnchor,
                             width: self.frame.width / CGFloat(ProfileFilterOptions.allCases.count),
                             height: 2)
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}

// MARK: - UICollectionViewDelegate
extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        let xPos = cell.frame.origin.x
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.underLineView.frame.origin.x = xPos
        }
        
        self.delegate?.filterView(self, didSelectItemAt: indexPath)
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileFilterView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIden, for: indexPath) as? ProfileFilterCell else {
            return UICollectionViewCell()
        }
        let options = ProfileFilterOptions(rawValue: indexPath.row)
        cell.options = options
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.frame.width / CGFloat(ProfileFilterOptions.allCases.count), height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

