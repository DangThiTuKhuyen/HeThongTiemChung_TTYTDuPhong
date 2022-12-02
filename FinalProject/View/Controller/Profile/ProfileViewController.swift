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

final class ProfileViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    let dropDown = DropDown()
    var viewModel: ProfileViewModel?
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

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavi()
        configTableView()
        getProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfile()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(viewModel?.info)
    }

    // MARK: - Private func
    private func getProfile() {
        guard let viewModel = viewModel else { return }
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
        guard let index = index,
            let cell = tableView.cellForRow(at: index) as? CommonTableCell else { return }
        let viewModel = cell.viewModel
        switch viewModel?.type {
        case .avatar:
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

    private func updateNameCellWithoutDoneButton() {
        guard let index = selectedIndexPath, let cell = tableView.cellForRow(at: index) as? CommonTableCell else { return }
        cell.updateValueTextField()
    }

    // MARK: - Objc func
    @objc private func keyboardDidHide(_ sender: Any?) {
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

    @objc private func keyboardWillShow(_ sender: Any?) {
        isAppearKeyboard = true
    }
}

// MARK: - UITableViewDataSource
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
            cell.delegate = self
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

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        guard !isAppearKeyboard else {
            view.endEditing(true)
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.getIndex(indexPath)
        guard let sectionType = ProfileViewModel.SectionType(rawValue: indexPath.section) else { return }
        let type = sectionType.rows[indexPath.row]
        switch type {
        case .avatar, .name, .email, .identityCard:
            break
        case .numberPhone, .birthday:
//            selectedIndexPath = indexPath
            break
        case .gender:
            if let cell = tableView.cellForRow(at: indexPath) {
                dropDown.dataSource = ["Male", "Female"]
                dropDown.anchorView = cell
                dropDown.bottomOffset = CGPoint(x: 0, y: cell.frame.size.height)
                dropDown.backgroundColor = .orange
                dropDown.show()
                dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                    guard self != nil else { return }
                    viewModel.setGender(value: item)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }

        case .province:
            let vc = ProvinceViewController()
            vc.viewModel = ProvinceViewModel(chooseProvince: viewModel.info?.province ?? "")
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .district:
            let vc = DistrictViewController()
            vc.viewModel = DistrictViewModel(districts: viewModel.getDistrictForProvince(), chooseDistrict: viewModel.info?.district ?? "")
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .changePass:
            print("changepasss")
        case .logout:
            print("logout")
        }
    }

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

// MARK: - NewAvatarTableCellDelegate
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
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CommonTableCellDelegate
extension ProfileViewController: CommonTableCellDelegate {
    func cell(_ cell: CommonTableCell, needsPerformAction action: CommonTableCell.Action) {
        switch action {
        case .valueChanged(valueString: let valueString):
            viewModel?.setPhone(value: valueString)
        }
        selectedIndexPath = nil
    }
}

extension RegisterViewController: CommonTableCellDataSource {
    func updateCellProvince(_ cell: CommonTableCell) -> String {
        return viewModel.userInfo.province
    }

    func updateCellDistrict(_ cell: CommonTableCell) -> String {
        return viewModel.userInfo.district
    }
}

// MARK: -

extension ProfileViewController: ProvinceViewControllerDelegate {
    func controller(_ controller: ProvinceViewController, neesPerformAction action: ProvinceViewController.Action) {
        switch action {
        case .updateProvince(let address):
            if viewModel?.info?.province != address.province {
                viewModel?.setProvince(value: address)
                viewModel?.setDistrict(value: "")
                tableView.reloadRows(at: [IndexPath(row: 3, section: 1)], with: .automatic)
                tableView.reloadRows(at: [IndexPath(row: 4, section: 1)], with: .automatic)
            }
        }
    }
}

extension ProfileViewController: DistrictViewControllerDelegate {
    func controller(_ controller: DistrictViewController, needPerformAction action: DistrictViewController.Action) {
        switch action {
        case .updateDistrict(district: let district):
            viewModel?.setDistrict(value: district)
            tableView.reloadRows(at: [IndexPath(row: 4, section: 1)], with: .automatic)
        }
    }
}
