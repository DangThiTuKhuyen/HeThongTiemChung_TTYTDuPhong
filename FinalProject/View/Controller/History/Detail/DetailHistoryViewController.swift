//
//  DetailHistoryViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

class DetailHistoryViewController: UIViewController {

//    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = DetailHistoryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configTableView()
    }

    private func configUI() {
        
//        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        containerView.layer.cornerRadius = 20
//        containerView.layer.masksToBounds = true
    }
    
    private func configTableView() {
        tableView.register(DetailHistoryCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension DetailHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DetailHistoryCell.self)
        cell.delegate = self
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

extension DetailHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailHistoryViewController: DetailHistoryCellDelegate {
    func cell(_ cell: DetailHistoryCell, needPerformAction action: DetailHistoryCell.Action) {
        switch action {
        case .updateCell:
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            viewModel.isShows[indexPath.row] = !viewModel.isShows[indexPath.row] 
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}
