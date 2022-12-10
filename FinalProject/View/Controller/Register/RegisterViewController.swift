//
//  RegisterViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 07/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import DropDown

final class RegisterViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = RegisterViewModel()

    private(set) var selectedIndexPath: IndexPath? {
        willSet {
            updateCellStatusForName(at: newValue, isSelected: true)
        }
        didSet {
            updateCellStatusForName(at: oldValue, isSelected: false)
        }
    }

    private func updateCellStatusForName(at index: IndexPath?, isSelected: Bool) {
        guard let index = index,
            let cell = tableView.cellForRow(at: index) as? CommonCell else { return }
        let viewModel = cell.viewModel
        switch viewModel?.type {
        case .district, .province, .gender:
            break
        default:
            viewModel?.updateCellStatus(isSlelected: isSelected)
            cell.updateUI()
        }
    }

    private(set) var isAppearKeyboard: Bool = false

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false

    }

    private func updateNameCellWithoutDoneButton() {
        guard let index = selectedIndexPath, let cell = tableView.cellForRow(at: index) as? CommonCell else { return }
        cell.updateValueTextField()
    }

    @objc private func keyboardDidHide(_ sender: Any?) {
        DispatchQueue.main.async {
            self.isAppearKeyboard = false
            self.updateCellStatusForName(at: self.selectedIndexPath, isSelected: false)
            self.updateNameCellWithoutDoneButton()
            self.selectedIndexPath = nil
            UIView.setAnimationsEnabled(false)
//            self.tableView.reloadData()
            UIView.setAnimationsEnabled(true)
        }
    }

    @objc private func keyboardWillShow(_ sender: Any?) {
        isAppearKeyboard = true
    }

    // MARK: - Override func
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Private func
    private func configTableView() {
        tableView.register(CommonCell.self)
        tableView.register(GenderCell.self)
        tableView.register(BirthdayCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
    }

    private func pushToEnterPassCode() {
        let vc = EnterPassCodeViewController()
        vc.viewModel = EnterPassCodeViewModel(email: viewModel.userInfo.email)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: IBActions

    @IBAction private func signUpButtonTouchUpInside(_ sender: UIButton) {
        HUD.show()
        viewModel.registerAccount { [weak self] result in
            HUD.dismiss()

            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.pushToEnterPassCode()
                case .failure(let error):
                    this.alert(msg: error, handler: nil)
                }
            }

        }
    }
}

// MARK: - UITableViewDataSource
extension RegisterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = RegisterProfileType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        switch type {
        case .gender:
            let cell = tableView.dequeue(GenderCell.self)
            cell.delegate = self
            return cell
        case .province, .district:
            let cell = tableView.dequeue(CommonCell.self)
            cell.dataSource = self
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonCellViewModel
            return cell
        case .birthday:
            let cell = tableView.dequeue(BirthdayCell.self)
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? BirthdayCellViewModel
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeue(CommonCell.self)
            cell.delegate = self
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonCellViewModel
            return cell
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    }
}
// MARK: - UITableViewDelegate
extension RegisterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isAppearKeyboard else {
            view.endEditing(true)
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        guard let type = RegisterProfileType(rawValue: indexPath.row) else { return }
        switch type {
        case .province:
            let vc = ProvinceViewController()
            vc.viewModel = ProvinceViewModel(chooseProvince: viewModel.address?.province ?? "")
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .district:
            let vc = DistrictViewController()
            vc.viewModel = DistrictViewModel(districts: viewModel.getDistrict(), chooseDistrict: viewModel.userInfo.district)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .gender:
            break
//        case .birthday:
//            guard let cell = cell as? BirthdayCell else {
//                return
//            }
//            cell.chexckStatus = !cell.chexckStatus
        default:
            selectedIndexPath = indexPath
        }
    }
}

// MARK: - ProvinceViewControllerDelegate
extension RegisterViewController: ProvinceViewControllerDelegate {

    func controller(_ controller: ProvinceViewController, neesPerformAction action: ProvinceViewController.Action) {
        switch action {
        case .updateProvince(province: let address):
            if viewModel.address?.province != address.province {
                viewModel.address = address
                viewModel.setProvince()
                viewModel.setDistrict(district: "")
                tableView.reloadRows(at: [IndexPath(row: RegisterProfileType.province.rawValue, section: 0)], with: .automatic)
                tableView.reloadRows(at: [IndexPath(row: RegisterProfileType.district.rawValue, section: 0)], with: .automatic)
            }
        }
    }
}

// MARK: - DistrictViewControllerDelegate
extension RegisterViewController: DistrictViewControllerDelegate {
    func controller(_ controller: DistrictViewController, needPerformAction action: DistrictViewController.Action) {
        switch action {
        case .updateDistrict(district: let district):
            viewModel.setDistrict(district: district)
            tableView.reloadRows(at: [IndexPath(row: RegisterProfileType.district.rawValue, section: 0)], with: .automatic)
        }
    }
}

// MARK: - CommonCellDataSource
extension RegisterViewController: CommonCellDataSource {
    func updateCellProvince(_ cell: CommonCell) -> String {
        return viewModel.address?.province ?? ""
    }

    func updateCellDistrict(_ cell: CommonCell) -> String {
        return viewModel.userInfo.district
    }
}

// MARK: - CommonCellDelegate
extension RegisterViewController: CommonCellDelegate {
    func cell(_ cell: CommonCell, needPerformAction action: CommonCell.Action) {
        switch action {
        case .done(let value, let type):
            switch type {
            case .name:
                viewModel.setName(name: value)
            case .birthday:
                viewModel.setBirthday(birthday: value)
            case .email:
                viewModel.setEmail(email: value)
            case .phoneNumber:
                viewModel.setPhoneNumber(phoneNumber: value)
            case .identityCard:
                viewModel.setIdentityCard(id: value)
            default:
                break
            }
            tableView.reloadRows(at: [IndexPath(row: type.rawValue, section: 0)], with: .automatic)
        }
    }
}

extension RegisterViewController: GenderCellDelegate {
    func cell(_ cell: GenderCell, needPerformAction action: GenderCell.Action) {
        switch action {
        case.done(let value):
            viewModel.setGender(gender: value)
        }
    }
}

extension RegisterViewController: BirthdayCellDelegate {
    func cell(_ cell: BirthdayCell, needPerformAction action: BirthdayCell.Action) {
        switch action {
        case .done(let value, let type):
            viewModel.setBirthday(birthday: value)
            tableView.reloadRows(at: [IndexPath(row: type.rawValue, section: 0)], with: .automatic)
        }
    }
}
