//
//  ViewControllerExtension.swift
//  Project
//
//  Created by Be More on 10/3/20.
//

import UIKit

extension UIViewController {
    
    /// Add accessory to text field
    ///
    /// - Parameters:
    ///   - textFields: add  to text field
    ///   - dismissable: can be dissmisssed
    ///   - previousNextable: can move to other text field
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
    
    func presentError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    func presentMessage(_ message: String) {
        let alertController = UIAlertController(title: "Message",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    func presentMessage(_ message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Message",
                                                message: message,
                                                preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: handler)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
