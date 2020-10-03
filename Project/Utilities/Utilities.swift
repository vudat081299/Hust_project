//
//  Utilities.swift
//  Project
//
//  Created by Be More on 9/29/20.
//

import UIKit

class Utilities {
    func inputContainerView(image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        
        let iconImage = UIImageView()
        iconImage.image = image.withRenderingMode(.alwaysTemplate)
        iconImage.tintColor = .black
        view.addSubview(iconImage)
        iconImage.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8, width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iconImage.rightAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8,
                         paddingBottom: 8,
                         paddingRight: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        view.addSubview(dividerView)
        dividerView.anchor(left: iconImage.leftAnchor, bottom: view.bottomAnchor, right: textField.rightAnchor, height: 0.75)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return textField
    }
    
    func attributeButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}

extension UIViewController {
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "Backward_Arrow"), style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: UIImage(named: "Forward_Arrow"), style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
}
