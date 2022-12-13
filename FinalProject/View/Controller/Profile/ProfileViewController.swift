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
import AWSS3
import AWSCore

final class ProfileViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    let dropDown = DropDown()
    var viewModel: ProfileViewModel?
    var image: UIImage = UIImage()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavi()
        configTableView()
        getProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//    }

    // MARK: - Private func

    private func configNavi() {
        title = "My profile"
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save change", style: .plain, target: self, action: #selector(updateProfile))
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

    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }

    @objc private func updateProfile() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.updateProfile { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.alert(msg: "Update profile succesfully", handler: nil)
                case .failure(let error):
                    this.alert(msg: error, handler: nil)
                }
            }
        }
    }

    func uploadImage(image: UIImage) {
        AuthService.uploadImage { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let urlUpload):
                this.uploadAWSS3(image: image, url: urlUpload)
            case .failure(let error):
                this.alert(msg: error.localizedDescription, handler: nil)
            }
        }
    }

    func uploadAWSS3(image: UIImage, url: String) {
        AuthService.uploadAWSS3(image: image, urlUpload: url) { [weak self] result in
            DispatchQueue.main.async {
                if result ?? false {
                    print("succes")
                } else {
                    print("fail")
                }
            }
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.getIndex(indexPath)
        guard let sectionType = ProfileViewModel.SectionType(rawValue: indexPath.section) else { return }
        let type = sectionType.rows[indexPath.row]
        switch type {
        case .avatar, .name, .email, .identityCard:
            break
        case .numberPhone:
            break
        case .birthday:
            break
        case .gender:
            if let cell = tableView.cellForRow(at: indexPath) {
                dropDown.dataSource = ["male", "female"]
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
            let vc = ChangePasswordViewController()
            vc.viewModel = ChangePasswordViewModel()
            navigationController?.pushViewController(vc, animated: true)
        case .logout:
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logOut"), object: nil)
            }
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
            self.image = image
            let imageResized = image.resized(withPercentage: 0.2) ?? image
            uploadImage(image: imageResized)
            
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
        case .valueChanged(let value, let type):
            switch type {
            case .numberPhone:
                viewModel?.setPhone(value: value)
            case .birthday:
                viewModel?.setBirthday(value: value)
            default:
                break
            }
        }
    }
}

// MARK: - ProvinceViewControllerDelegate

extension ProfileViewController: ProvinceViewControllerDelegate {
    func controller(_ controller: ProvinceViewController, neesPerformAction action: ProvinceViewController.Action) {
        switch action {
        case .updateProvince(let address):
            if viewModel?.info?.province != address.province {
                viewModel?.setProvince(value: address)
                viewModel?.setDistrict(value: "")
                tableView.reloadRows(at: [IndexPath(row: 3, section: SectionType.infomation.rawValue)], with: .automatic)
                tableView.reloadRows(at: [IndexPath(row: 4, section: SectionType.infomation.rawValue)], with: .automatic)
            }
        }
    }
}

// MARK: - DistrictViewControllerDelegate
extension ProfileViewController: DistrictViewControllerDelegate {
    func controller(_ controller: DistrictViewController, needPerformAction action: DistrictViewController.Action) {
        switch action {
        case .updateDistrict(district: let district):
            guard let viewModel = viewModel else { return }
            viewModel.setDistrict(value: district)
            tableView.reloadRows(at: [IndexPath(row: 4, section: SectionType.infomation.rawValue)], with: .automatic)
        }
    }
}

// MARK: - Extension
extension UserDefaults {

    enum Keys: String, CaseIterable {

        case accessToken
        case refreshToken
        case userId
        case email
        case userName
    }

    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}
