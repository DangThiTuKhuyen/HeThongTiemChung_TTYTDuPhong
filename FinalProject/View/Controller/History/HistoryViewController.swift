//
//  HistoryViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: HistoryViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configTableView()
    }

    private func configUI() {
        navigationController?.isNavigationBarHidden = false
        title = "History"
    }
    
    private func configTableView() {
        tableView.register(HistoryCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel?.numberOfRowInSection() ?? 0
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HistoryCell.self)
        cell.delegate = self
//        cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonCellViewModel
        return cell
    }
}
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailHistoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HistoryViewController: HistoryCellDelegate {
    func cell(_ cell: HistoryCell, needPerform action: HistoryCell.Action) {
        switch action {
        case .goToDetail:
            let vc = DetailHistoryViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
