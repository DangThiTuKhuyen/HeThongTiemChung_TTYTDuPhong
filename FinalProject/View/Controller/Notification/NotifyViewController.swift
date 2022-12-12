//
//  NotifyViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 06/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class NotifyViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = NotifyViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configUI()
        getNotify()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotify()
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private func
    private func configUI() {
        title = "Notifications"
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
    }

    private func configTableView() {
        tableView.register(NotifyCell.self)
        tableView.dataSource = self
    }

    private func getNotify() {
        HUD.show()
        viewModel.getNotify { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.tableView.reloadData()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }
}

extension NotifyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NotifyCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        cell.delegate = self
        return cell
    }
}

extension NotifyViewController: NotifyCellDelegate {
    func cell(_ cell: NotifyCell, needPerform action: NotifyCell.Action) {
        switch action {
        case .goToDetail:
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let vc = DetailNotifyViewController()
            vc.viewModel = DetailNotifyViewModel(notify: viewModel.notities[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
