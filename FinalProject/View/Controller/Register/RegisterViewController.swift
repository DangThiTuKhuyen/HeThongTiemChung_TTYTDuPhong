//
//  RegisterViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 07/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import DropDown

final class RegisterViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = RegisterViewModel()
    var color = UIColor(red: 0.53, green: 0.81, blue: 0.98, alpha: 1.00)
    

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
    }

    // MARK: IBActions
    @IBAction private func backToPreviousButtonTouchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func signUpButtonTouchUpInside(_ sender: UIButton) {
        print(viewModel.userInfo)
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
            return cell
        case .province, .district:
            let cell = tableView.dequeue(CommonCell.self)
            cell.dataSource = self
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonCellViewModel
            return cell
        default:
            let cell = tableView.dequeue(CommonCell.self)
            cell.delegate = self
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonCellViewModel
            return cell
        }
    }
}
// MARK: - UITableViewDelegate
extension RegisterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundConfiguration = .clear()
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
        default:
            break
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
//            viewModel.district = district
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

extension RegisterViewController: CommonCellDelegate {
    func cell(_ cell: CommonCell, needPerformAction action: CommonCell.Action) {
        switch action {
        case .done(let value, let type):
            switch type {
            case .name:
                viewModel.setName(name: value)
            case .birthday:
                viewModel.setBirthday(birthday: value)
            case .province:
                break
            case .district:
                break
            case .email:
                viewModel.setEmail(email: value)
            case .phoneNumber:
                viewModel.setPhoneNumber(phoneNumber: value)
            case .gender:
                break
            case .password:
                viewModel.setPassword(password: value)
            }
        }
    }
}
