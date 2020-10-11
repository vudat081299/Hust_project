//
//  BindingTextField.swift
//  Project
//
//  Created by Be More on 10/11/20.
//

import UIKit

class BindingTextField: UITextField {
    
    var textChangeClosure: (String) -> () = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commondInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commondInit()
    }
    
    private func commondInit() {
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func bind(callBack: @escaping (String) -> ()) {
        self.textChangeClosure = callBack
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        print(text)
        self.textChangeClosure(text)
    }
}

