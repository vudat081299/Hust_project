//
//  ProfileFilterCell.swift
//  Project
//
//  Created by Be More on 10/16/20.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    // MARK: - Properties
    
    var options: ProfileFilterOptions! {
        didSet {
            self.titleLabel.text = options.description
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            self.titleLabel.font = self.isSelected ? UIFont.boldSystemFont(ofSize: 14) : UIFont.systemFont(ofSize: 14)
            self.titleLabel.textColor = self.isSelected ? .twitterBlue : .lightGray
        }
    }
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(self.titleLabel)
        self.titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
}
