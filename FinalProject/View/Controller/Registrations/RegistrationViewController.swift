//
//  RegistrationViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 22/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class RegistrationViewController: UIViewController {


    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noResultLabel: UILabel!

    var viewModel: RegistrationViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        getRegistrations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUI()
        getRegistrations()
    }

    // MARK: - Private func

    private func getRegistrations() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getRegistrations { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.updateUI()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func configUI() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = "Registrations"
    }

    private func configTableView() {
        tableView.register(RegistrationCell.self)
        tableView.dataSource = self
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        tableView.reloadData()
        tableView.isHidden = !viewModel.isShowTableView()
        noResultLabel.isHidden = viewModel.isShowTableView()
    }
}

// MARK: - UITableViewDataSource
extension RegistrationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(RegistrationCell.self)
        cell.delegate = self
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - RegistrationCellDelegate
extension RegistrationViewController: RegistrationCellDelegate {
    func cell(_ cell: RegistrationCell, needPerform action: RegistrationCell.Action) {
        switch action {
        case .goToDetail:
            guard let viewModel = viewModel, let indexPath = tableView.indexPath(for: cell) else { return }
            let vc = RegisterInfoViewController()
            vc.viewModel = RegisterInfoViewModel(registerInfo: viewModel.getRegistrationSelected(at: indexPath), diseaseName: viewModel.getNameDisease(at: indexPath), type: .update)
            vc.viewModel?.registrationId = viewModel.getRegistrationId(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
