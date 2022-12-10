//
//  AppointmentViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class AppointmentViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    var viewModel: AppointmentViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        getAppointment()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUI()
//        getAppointment()
    }

    // MARK: - Private func

    private func getAppointment() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getAppointment { [weak self] result in
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

    private func configUI() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = "Your Appointment"
    }

    private func configTableView() {
        tableView.register(AppointmentCell.self)
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension AppointmentViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(AppointmentCell.self)
        cell.delegate = self
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}
// MARK: - AppointmentCellDelegate
extension AppointmentViewController: AppointmentCellDelegate {
    func cell(_ cell: AppointmentCell, needPerform action: AppointmentCell.Action) {
        switch action {
        case .goToDetail:
            guard let viewModel = viewModel, let indexPath = tableView.indexPath(for: cell) else { return }
            
            //        let loginNaviC = UINavigationController(rootViewController: loginVc)
            //        loginNaviC.modalPresentationStyle = .fullScreen
            //        present(loginNaviC, animated: true)
            let vc = DetailAppointmentViewController()
            vc.viewModel = DetailAppointmentViewModel(appointment: viewModel.appointments[indexPath.row])
            let vcNavi = UINavigationController(rootViewController: vc)
            vcNavi.modalPresentationStyle = .formSheet
            present(vcNavi, animated: true)
        }
    }

}
