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
        default:
            let cell = tableView.dequeue(CommonCell.self)
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonCellViewModel
            return cell
        }
    }
}

extension RegisterViewController: UITableViewDelegate {
}
