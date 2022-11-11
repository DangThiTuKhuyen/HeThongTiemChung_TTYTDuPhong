//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 02/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import DropDown

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let dropDown = DropDown()
    var viewModel = ProfileViewModel()
    var image: UIImage = UIImage()

    private(set) var selectedIndexPath: IndexPath? {
        willSet {
            updateCellStatusForName(at: newValue, isSelected: true)
        }
        didSet {
            updateCellStatusForName(at: oldValue, isSelected: false)
        }
    }

    private(set) var isAppearKeyboard: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configNavi()
        getProfile()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    private func getProfile() {
        HUD.show()
        viewModel.getProfile { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.tableView.reloadData()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func updateCellStatusForName(at index: IndexPath?, isSelected: Bool) {
        guard let index = index, let cell = tableView.cellForRow(at: index) as? CommonTableCell else { return }
        let viewModel = cell.viewModel
        viewModel?.updateCellStatus(isSlelected: isSelected)
        cell.updateUI()
    }

    private func configNavi() {
        title = "My profile"
        navigationController?.navigationBar.barTintColor = .white
    }

    private func configTableView() {
        tableView.register(NewAvatarTableCell.self)
        tableView.register(CommonTableCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
    }

    @objc func keyboardDidHide(_ sender: Any?) {
        DispatchQueue.main.async {
            self.isAppearKeyboard = false
            self.updateCellStatusForName(at: self.selectedIndexPath, isSelected: false)
            self.updateNameCellWithoutDoneButton()
            self.selectedIndexPath = nil
            UIView.setAnimationsEnabled(false)
            self.tableView.reloadData()
            UIView.setAnimationsEnabled(true)
        }
    }

    @objc func keyboardWillShow(_ sender: Any?) {
        isAppearKeyboard = true
    }

    private func updateNameCellWithoutDoneButton() {
        guard let index = selectedIndexPath, let cell = tableView.cellForRow(at: index) as? CommonTableCell else { return }
        cell.updateValueTextField()
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = ProfileType(rawValue: indexPath.row) else { return UITableViewCell() }
        switch type {
        case .avatar:
            let cell = tableView.dequeue(NewAvatarTableCell.self)
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? NewAvatarCellViewModel
            cell.delegate = self
            cell.dataSource = self
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = bgColorView
            return cell
        default:
            let cell = tableView.dequeue(CommonTableCell.self)
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonTableCellViewModel
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = bgColorView
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard !isAppearKeyboard else {
            view.endEditing(true)
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.getIndex(indexPath)
//        let cell = tableView.cellForRow(at: indexPath) as? CommonTableCell
        guard let type = ProfileType(rawValue: indexPath.row) else { return }
        switch type {
        case .avatar:
            break
        case .name:
            print("Name")
        case .email:
            print("email")
        case .numberPhone:
            print("phone")
        case .gender:
            if let cell = tableView.cellForRow(at: indexPath) {
                dropDown.dataSource = ["Male", "Female"]
                dropDown.anchorView = cell
                dropDown.bottomOffset = CGPoint(x: 0, y: cell.frame.size.height + 100)
                dropDown.backgroundColor = .orange
                dropDown.show()
                dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                    guard let _ = self else { return }
                    print(index)
                    print(item)
                }
            }

        case .birthday:
            break
        case .province:
            let vc = ProvinceViewController()
            vc.viewModel = ProvinceViewModel(chooseProvince: "Tỉnh Quảng Ngãi")
//            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .district:
            let vc = DistrictViewController()
//            vc.viewModel = DistrictViewModel(districts: viewModel.getDistrict(), chooseDistrict: viewModel.userInfo.district)
//            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
        selectedIndexPath = indexPath
    }
}

extension ProfileViewController: NewAvatarTableCellDelegate {
    func cell(_ view: NewAvatarTableCell, needsPerformAction action: NewAvatarTableCell.Action) {
        switch action {
        case .edit:
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        }
    }
}

extension ProfileViewController: NewAvatarTableCellDataSource {
    func updateAvatar(_ cell: NewAvatarTableCell) -> UIImage {
        return image
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: CommonTableCellDelegate {
    func cell(_ cell: CommonTableCell, needsPerformAction action: CommonTableCell.Action) {
        switch action {
        case .valueChanged(valueString: let valueString):
            print("aaaaaaa\(valueString)")
        }
        selectedIndexPath = nil
    }
}
