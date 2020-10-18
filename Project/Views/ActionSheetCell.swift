//
//  ActionSheetCell.swift
//  Project
//
//  Created by Be More on 10/18/20.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    // MARK: - Properties
    
    var option: ActionSheetOption? {
        didSet {
            configure()
        }
    }
    
    private lazy var optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "twitter_logo_blue")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.optionImageView)
        
        self.optionImageView.centerY(inView: self.contentView)
        self.optionImageView.anchor(left: self.contentView.leftAnchor,
                                    paddingLeft: 8)
        
        self.optionImageView.setDimensions(width: 36,
                                           height: 36)
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.centerY(inView: self.optionImageView)
        self.titleLabel.anchor(left: self.optionImageView.rightAnchor,
                               paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        guard let option = self.option else { return }
        self.titleLabel.text = option.description
    }
}
