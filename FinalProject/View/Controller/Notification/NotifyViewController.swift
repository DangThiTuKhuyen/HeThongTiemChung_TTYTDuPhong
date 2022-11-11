//
//  NotifyViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 06/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class NotifyViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    private func configTableView() {
        tableView.register(NotifyCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension NotifyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NotifyCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let loginVc = LoginViewController()
//        let loginNaviC = UINavigationController(rootViewController: loginVc)
//        loginNaviC.modalPresentationStyle = .fullScreen
//        present(loginNaviC, animated: true)
    }
}

extension NotifyViewController: UITableViewDelegate {
}
