//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 02/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import DropDown
import SwiftUtils

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let dropDown = DropDown()
    var viewModel: ProfileViewModel?
    var image: UIImage = UIImage()

    private(set) var selectedIndexPath: IndexPath? {
        willSet {
            updateCellStatusForName(at: newValue, isSelected: true)
        }
        didSet {
            updateCellStatusForName(at: oldValue, isSelected: false )
        }
    }

    private(set) var isAppearKeyboard: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavi()
        getProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    private func getProfile() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getProfile { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.configTableView()
                    this.tableView.reloadData()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func updateCellStatusForName(at index: IndexPath?, isSelected: Bool) {
        guard let index = index,
            let cell = tableView.cellForRow(at: index) as? CommonTableCell else { return }
        let viewModel = cell.viewModel
        switch viewModel?.type {
        case .avatar :
            break
        default:
            viewModel?.updateCellStatus(isSlelected: isSelected)
            cell.updateUI()
        }
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
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.sectionFooterHeight = 0
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
//        guard let index = selectedIndexPath, let cell = tableView.cellForRow(at: index) as? CommonTableCell else { return }
//        cell.updateValueTextField()
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSection() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowInSection(inSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        guard let sectionType = ProfileViewModel.SectionType(rawValue: indexPath.section) else { return UITableViewCell() }
        let type = sectionType.rows[indexPath.row]
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = ProfileViewModel.SectionType(rawValue: section) else { return nil }
                switch sectionType {
                case .identity:
                    return nil
                default:
                    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 40))
                    let label = UILabel()
                    label.frame = CGRect(x: 10, y: 10, width: headerView.frame.width - 10, height: headerView.frame.height - 20)
                    label.text = sectionType == .infomation ? "Information" : "Security"
                    label.font = .systemFont(ofSize: 17)
                    label.textColor = .black
                    headerView.addSubview(label)
                    return headerView
                }
        }
}

extension ProfileViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let viewModel = viewModel else { return }
//        guard !isAppearKeyboard else {
//            view.endEditing(true)
//            return
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
//        viewModel.getIndex(indexPath)
//        guard let sectionType = ProfileViewModel.SectionType(rawValue: indexPath.section) else { return }
//        let type = sectionType.rows[indexPath.row]
//        switch type {
//        case .avatar:
//            break
//        case .name:
//            print("Name")
//        case .email:
//            print("email")
//        case .identityCard:
//            print("identityCard")
//        case .numberPhone:
//            print("phone")
//        case .gender:
//            if let cell = tableView.cellForRow(at: indexPath) {
//                dropDown.dataSource = ["Male", "Female"]
//                dropDown.anchorView = cell
//                dropDown.bottomOffset = CGPoint(x: 0, y: cell.frame.size.height)
//                dropDown.backgroundColor = .orange
//                dropDown.show()
//                dropDown.selectionAction = { [weak self] (index: Int, item: String) in
//                    guard let _ = self else { return }
//                    print(index)
//                    print(item)
//                }
//            }
//
//        case .birthday:
//            break
//        case .province:
//            let vc = ProvinceViewController()
//            vc.viewModel = ProvinceViewModel(chooseProvince: "Tỉnh Quảng Ngãi")
////            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
//        case .district:
//            let vc = DistrictViewController()
////            vc.viewModel = DistrictViewModel(districts: viewModel.getDistrict(), chooseDistrict: viewModel.userInfo.district)
////            vc.delegate = self
//            navigationController?.pushViewController(vc, animated: true)
//        case .changePass:
//            print("changepasss")
//        case .logout:
//            print("logout")
//        }
//        selectedIndexPath = indexPath
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = ProfileViewModel.SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .identity:
            return 0
        default:
            return 40
        }
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
