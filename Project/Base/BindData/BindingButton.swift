//
//  BindingButton.swift
//  Project
//
//  Created by Be More on 10/11/20.
//

import UIKit

class BindingButton: UIButton {
    
    var didTapButton: () -> () = {  }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commontInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commontInit()
    }
    
    func bind(callBack: @escaping () -> ()) {
        self.didTapButton = callBack
    }
    
    private func commontInit() {
        self.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        self.didTapButton()
    }
}
