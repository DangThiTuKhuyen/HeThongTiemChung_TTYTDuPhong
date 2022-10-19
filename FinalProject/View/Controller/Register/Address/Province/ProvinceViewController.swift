//
//  AddressViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 14/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

// MARK: - ProvinceViewControllerDelegate
protocol ProvinceViewControllerDelegate: AnyObject {
    func controller(_ controller: ProvinceViewController, neesPerformAction action: ProvinceViewController.Action)
}

final class ProvinceViewController: UIViewController {

    // MARK: - Enum
    enum Action {
        case updateProvince(province: Address)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: ProvinceViewModel?
    weak var delegate: ProvinceViewControllerDelegate?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        getProvince()
        configTableView()
        setupNavi()
    }

    // MARK: - Private func
    private func getProvince() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getProvince { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.tableView.reloadData()
                    viewModel.setChooseProvince()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func configTableView() {
        tableView.register(ProvinceCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupNavi() {
        title = "Province"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(chooseProvince))
    }

    // MARK: - Objc func
    @objc private func chooseProvince() {
        guard let viewModel = viewModel else { return }
        delegate?.controller(self, neesPerformAction: .updateProvince(province: viewModel.getAddressSelected()))
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProvinceViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(ProvinceCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath, selected: viewModel.selectedIndexPath == indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProvinceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectedIndexPath = indexPath
        tableView.reloadData()
    }
}
