//
//  EditProfileCell.swift
//  Project
//
//  Created by Be More on 10/25/20.
//

import UIKit

protocol EditProfileCellDelegate: class {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    // MARK: - Properties.
    
    weak var delegate: EditProfileCellDelegate?
    
    var viewModel: EditProfileViewModel? {
        didSet {
            self.configure()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .twitterBlue
        textField.text = "Test Info"
        textField.addTarget(self, action: #selector(handleUpdateUserInfo(_:)), for: .editingDidEnd)
        return textField
    }()
    
    let bioTextView: CaptionTextView = {
        let textView = CaptionTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .twitterBlue
        textView.placeHolderLabel.text = "Bio"
        return textView
    }()
    
    // MARK: - Lifecycles.
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.anchor(top: self.contentView.topAnchor,
                               left: self.contentView.leftAnchor,
                               paddingTop: 12,
                               paddingLeft: 16,
                               width: 100)
        
        self.contentView.addSubview(self.infoTextField)
        
        self.infoTextField.anchor(top: self.contentView.topAnchor,
                                  left: self.titleLabel.rightAnchor,
                                  bottom: self.contentView.bottomAnchor,
                                  right: self.contentView.rightAnchor,
                                  paddingTop: 4,
                                  paddingLeft: 16,
                                  paddingRight: 8)
        
        self.contentView.addSubview(self.bioTextView)
        self.bioTextView.anchor(top: self.contentView.topAnchor,
                                left: self.titleLabel.rightAnchor,
                                bottom: self.contentView.bottomAnchor,
                                right: self.contentView.rightAnchor,
                                paddingTop: 4,
                                paddingLeft: 14,
                                paddingRight: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors.
    
    @objc private func handleUpdateUserInfo(_ sender: UITextField) {
        self.delegate?.updateUserInfo(self)
    }
    
    // MARK: - Helpers.
    
    private func configure() {
        guard let viewModel = self.viewModel else { return }
        self.infoTextField.isHidden = viewModel.shouldHideTextField
        self.bioTextView.isHidden = viewModel.shouldHideTextView
        
        self.titleLabel.text = viewModel.titleText
        self.infoTextField.text = viewModel.optionValue
        
        self.bioTextView.placeHolderLabel.isHidden = viewModel.shouldHidePlaceHolder
        self.bioTextView.text = viewModel.optionValue
    }
    
}
