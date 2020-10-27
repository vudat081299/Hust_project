//
//  EditProfileController.swift
//  Project
//
//  Created by Be More on 10/25/20.
//

import UIKit

private let cellIden = "EditProfileCell"

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantToUpdate user: User)
    func handleLogout()
}

class EditProfileController: UITableViewController {
    
    // MARK: - Properties.
    
    weak var delegate: EditProfileControllerDelegate?
    
    private var user: User
    
    private let footerView = EditProfileFooterView()
    
    private lazy var profileHeaderView = EditProfileHeader(user: self.user)
    
    private let imagePicker = UIImagePickerController()
    
    private var selectedImage: UIImage? {
        didSet {
            self.profileHeaderView.profileImageView.image = selectedImage
        }
    }
    
    private var userInfoChange: Bool = false
    
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    
    // MARK: - Lifecycles.
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    // MARK: - Selectors.
    
    @objc private func handleCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDone(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        guard imageChanged || userInfoChange else { return }
        self.updateUserData()
    }
    
    // MARK: - Api.
    
    private func updateUserData() {
        
        if imageChanged && !userInfoChange {
            self.updateProfileImage()
        }
        
        if !imageChanged && userInfoChange {
            UserService.shared.saveUserData(user: self.user) { [weak self] err, ref  in
                guard let `self` = self else { return }
                self.delegate?.controller(self, wantToUpdate: self.user)
            }
        }
        
        if imageChanged && userInfoChange {
            UserService.shared.saveUserData(user: self.user) { [weak self] err, ref  in
                guard let `self` = self else { return }
                self.updateProfileImage()
            }
        }
        
    }
    
    private func updateProfileImage() {
        guard let image = self.selectedImage else { return }
        
        UserService.shared.updateProfileImage(image: image) { [weak self] urlString in
            guard let `self` = self else { return }
            self.user.profileImageUrl = urlString
            self.delegate?.controller(self, wantToUpdate: self.user)
        }
    }
    
    // MARK: - Helper.
    
    private func configureUI() {
        self.configureNavigationBar()
        self.configureTableView()
        self.configureImagePicker()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .twitterBlue
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.title = "Edit Profile"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone(_:)))
        
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func configureTableView() {
        self.tableView.tableHeaderView = self.profileHeaderView
        self.profileHeaderView.delegate = self
        self.profileHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 180)
        
        self.footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        self.footerView.delegate = self
        self.tableView.tableFooterView = self.footerView
        self.tableView.register(EditProfileCell.self, forCellReuseIdentifier: cellIden)
    }
    
    private func configureImagePicker() {
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
    }
    
}

// MARK: - UITableViewDelegate.

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let options = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return options == .bio ? 100.0 : 48.0
    }
}

// MARK: - UITableViewDataSource.

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIden, for: indexPath) as? EditProfileCell else {
            return EditProfileCell()
        }
        guard let options = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.delegate = self
        cell.viewModel = EditProfileViewModel(user: self.user, options: options)
        return cell
    }
}

// MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    
    func didTapChangeProfilePhoto() {
        self.present(self.imagePicker, animated: true, completion: nil)
    }

}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        self.userInfoChange = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        switch viewModel.options {
        case .fullName:
            guard let fullName = cell.infoTextField.text else { return }
            user.fullName = fullName
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username
        case .bio:
            guard let bio = cell.bioTextView.text else { return }
            user.bio = bio
        }
    }
}

// MARK: - EditProfileFooterViewDelegate

extension EditProfileController: EditProfileFooterViewDelegate {
    
    func didTapLogout(_ footerView: EditProfileFooterView) {
        let alert = UIAlertController(title: nil, message: "Are your sure you want to log out?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { action in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }
        alert.addAction(logoutAction)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }

}
