//
//  DistrictViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

// MARK: - DistrictViewControllerDelegate
protocol DistrictViewControllerDelegate: AnyObject {
    func controller(_ controller: DistrictViewController, needPerformAction action: DistrictViewController.Action)
}

final class DistrictViewController: UIViewController {

    // MARK: - Enum
    enum Action {
        case updateDistrict(district: String)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel: DistrictViewModel?
    weak var delegate: DistrictViewControllerDelegate?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        viewModel.setChooseDistrict()
        configTableView()
        setupNavi()
    }

    // MARK: - Private func
    private func configTableView() {
        tableView.register(DistrictCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupNavi() {
        title = "District"
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(chooseDistrict))
    }

    // MARK: - Objc func
    @objc private func chooseDistrict() {
        guard let viewModel = viewModel else { return }
        delegate?.controller(self, needPerformAction: .updateDistrict(district: viewModel.getDistrictSelected()))
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension DistrictViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(DistrictCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath, selected: viewModel.selectedIndexPath == indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DistrictViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectedIndexPath = indexPath
        tableView.reloadData()
    }
}
