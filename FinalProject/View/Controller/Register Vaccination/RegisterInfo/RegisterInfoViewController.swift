//
//  RegisterInfoViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import SwiftUtils

class RegisterInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: RegisterInfoViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configUI()
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let height: CGFloat = 48.67 * CGFloat((viewModel?.numberOfRowInSection() ?? 0))
//        tableView.frame = CGRect(origin: tableView.frame.origin, size: CGSize(width: tableView.frame.width, height: height))
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    private func configUI() {
        title = "Registration"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func configTableView() {
        tableView.register(RegisterInfoCell.self)
        tableView.register(DatePickerCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
    }
}

extension RegisterInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel, let type = RegistionType(rawValue: indexPath.row) else { return UITableViewCell() }
        if type == .time {
            let cell = tableView.dequeue(DatePickerCell.self)
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? DatePickerCellViewModel
            return cell
        }
        let cell = tableView.dequeue(RegisterInfoCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? RegisterInfoCellViewModel
        return cell
    }
}

extension RegisterInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
