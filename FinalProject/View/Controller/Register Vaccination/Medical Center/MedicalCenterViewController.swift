//
//  MedicalCenterViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 23/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol MedicalCenterViewControllerDelegate: AnyObject {
    func controller(_ controller: MedicalCenterViewController, needPerformAction action: MedicalCenterViewController.Action)
}


final class MedicalCenterViewController: UIViewController {

    enum Action {
        case updateMedicalCenter(medicalCenter: MedicalCenter)
    }
    
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: MedicalCenterViewModel?
    weak var delegate: MedicalCenterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMedicalCenter()
        configTableView()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
    }

    private func getMedicalCenter() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getMedica { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.tableView.reloadData()
                    viewModel.setIndexPathSelected()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func configUI() {
        title = "Choose the medical center"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(chooseMedicalCenter))
    }

    private func configTableView() {
        tableView.register(MedicalCenterCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func chooseMedicalCenter() {
        guard let viewModel = viewModel else { return }
        delegate?.controller(self, needPerformAction: .updateMedicalCenter(medicalCenter: viewModel.getMedicalSelected()))
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MedicalCenterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowInsection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(MedicalCenterCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath, selected: viewModel.selectedIndexPath == indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MedicalCenterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectedIndexPath = indexPath
        tableView.reloadData()
    }
}
