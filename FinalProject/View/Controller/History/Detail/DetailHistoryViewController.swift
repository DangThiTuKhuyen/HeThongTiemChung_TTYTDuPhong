//
//  DetailHistoryViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class DetailHistoryViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: DetailHistoryViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configTableView()
    }

    // MARK: - Private func
    private func configUI() {
        title = "History details"
    }

    private func configTableView() {
        tableView.register(DetailHistoryCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension DetailHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowInSection() ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(DetailHistoryCell.self)
        cell.delegate = self
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DetailHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - DetailHistoryCellDelegate
extension DetailHistoryViewController: DetailHistoryCellDelegate {
    func cell(_ cell: DetailHistoryCell, needPerformAction action: DetailHistoryCell.Action) {
        switch action {
        case .updateCell:
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            viewModel?.updateStatus(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
