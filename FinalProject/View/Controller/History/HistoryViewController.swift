//
//  HistoryViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noResultLabel: UILabel!

    // MARK: - Properties
    var viewModel: HistoryViewModel?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configUI()
        getHistory()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUI()
    }

    // MARK: - Private func
    private func configTableView() {
        tableView.register(HistoryCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configUI() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        title = "History"
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        tableView.reloadData()
        tableView.isHidden = !viewModel.isShowTableView()
        noResultLabel.isHidden = viewModel.isShowTableView()
    }

    private func getHistory() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getHistory { [weak self] result in
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
}

// MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(HistoryCell.self)
        cell.delegate = self
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let vc = DetailHistoryViewController()
        vc.viewModel = DetailHistoryViewModel(history: viewModel.getHistorySelected(at: indexPath))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HistoryViewController: HistoryCellDelegate {

    func cell(_ cell: HistoryCell, needPerform action: HistoryCell.Action) {
        switch action {
        case .goToDetail:
            guard let viewModel = viewModel, let indexPath = tableView.indexPath(for: cell) else { return }
            let vc = DetailHistoryViewController()
            vc.viewModel = DetailHistoryViewModel(history: viewModel.getHistorySelected(at: indexPath))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
