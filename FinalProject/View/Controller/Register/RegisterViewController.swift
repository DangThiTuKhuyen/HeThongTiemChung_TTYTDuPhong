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
    var province: String = ""

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
//            birthdayTextField.resignFirstResponder()
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
    @IBAction func backToPreviousButtonTouchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
//            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? ProfileCognitoCellViewModel
            return cell
        case .province, .district:
            let cell = tableView.dequeue(CommonCell.self)
            cell.dataSource = self
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonCellViewModel
            return cell
        default:
            let cell = tableView.dequeue(CommonCell.self)
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonCellViewModel
            return cell
        }
    }
}

extension RegisterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("fsdfsdf")
        tableView.deselectRow(at: indexPath, animated: true)
        guard let type = RegisterProfileType(rawValue: indexPath.row) else { return }
        switch type {
        case .province:
            let vc = ProvinceViewController()
            vc.type = .province
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .district:
            let vc = ProvinceViewController()
            vc.type = .district
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension RegisterViewController: ProvinceViewControllerDelegate {
 
    func controller(_ controller: ProvinceViewController, neesPerformAction action: ProvinceViewController.Action) {
        switch action {
        case .updateProvince(province: let address):
            province = address.province
            tableView.reloadRows(at: [IndexPath(row: RegisterProfileType.province.rawValue, section: 0)], with: .automatic)
        }
    }
}

extension RegisterViewController: CommonCellDataSource {
    func updateData(_ cell: CommonCell) -> String {
        return province
    }
}
