//
//  ActionSheetLauncher.swift
//  Project
//
//  Created by Be More on 10/18/20.
//

import UIKit

private let cellIden = "ActionSheetCell"

protocol ActionSheetLaucherDelegate: class {
    func didSelect(option: ActionSheetOption)
}

class ActionSheetLaucher: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: ActionSheetLaucherDelegate?
    
    private var user: User
    private let actionTableView = UITableView()
    
    private lazy var viewModel = ActionSheetViewModel(self.user)
    
    private var height: CGFloat {
        return CGFloat(self.viewModel.option.count) * 60 + 100
    }
    
    private var window: UIWindow?
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmiss)))
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDissmiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(self.cancelButton)
        self.cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.cancelButton.anchor(left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 paddingLeft: 12,
                                 paddingRight: 12)
        self.cancelButton.centerY(inView: view)
        self.cancelButton.layer.cornerRadius = 50 / 2
        return view
    }()
    
    init(_ user: User) {
        self.user = user
        super.init()
        self.configureTableView()
    }
    
    func show() {
        self.window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        guard let window = self.window else { return }
        
        window.addSubview(self.blackView)
        self.blackView.frame = window.frame
        
        window.addSubview(self.actionTableView)
        self.actionTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.actionTableView.frame.origin.y -= self.height
        }
    }
    
    private func configureTableView() {
        self.actionTableView.backgroundColor = .white
        self.actionTableView.delegate = self
        self.actionTableView.dataSource = self
        self.actionTableView.rowHeight = 60
        self.actionTableView.separatorStyle = .none
        self.actionTableView.layer.cornerRadius = 5
        self.actionTableView.isScrollEnabled = false
        
        self.actionTableView.register(ActionSheetCell.self, forCellReuseIdentifier: cellIden)
    }
    
    // MARK: - Selectors
    
    @objc private func handleDissmiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.actionTableView.frame.origin.y += self.height
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ActionSheetLaucher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = self.viewModel.option[indexPath.row]
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.actionTableView.frame.origin.y += self.height
        } completion: { success in
            self.delegate?.didSelect(option: option)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}

// MARK: - UITableViewDataSource

extension ActionSheetLaucher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.option.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIden, for: indexPath) as? ActionSheetCell else {
            return ActionSheetCell()
        }
        cell.option = self.viewModel.option[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footerView
    }
}
