//
//  CaptionTextView.swift
//  Project
//
//  Created by Be More on 10/13/20.
//

import UIKit

class CaptionTextView: UITextView {
    
    // MARK: - Properties
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "What's happening?"
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.backgroundColor = .white
        
        self.font = UIFont.systemFont(ofSize: 16)
        
        self.isScrollEnabled = false
        
        self.addSubview(self.placeHolderLabel)
        
        self.placeHolderLabel.anchor(top: self.topAnchor,
                                     left: self.leftAnchor,
                                     paddingTop: 8,
                                     paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleChangeText), name: UITextView.textDidChangeNotification, object: nil)
    };
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Selectors
    
    @objc private func handleChangeText() {
        self.placeHolderLabel.isHidden = !self.text.isEmpty
    }
}
