//
//  RegisterInfoViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import SwiftUtils

class RegisterInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    var viewModel: RegisterInfoViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Private methods
    private func configUI() {
        title = "Registration"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(popToHome))
        cancelItem.tintColor = .red
        navigationItem.rightBarButtonItem = cancelItem

        guard let viewModel = viewModel, let status = viewModel.registerInfo.status, status == true else { return }
        deleteButton.isUserInteractionEnabled = !status
        confirmButton.isUserInteractionEnabled = !status
        deleteButton.alpha = 0.5
        confirmButton.alpha = 0.5
    }

    private func configTableView() {
        tableView.register(RegisterInfoCell.self)
        tableView.register(DatePickerCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
    }

    private func registerVaccine() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.registerVaccine { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.alert(msg: viewModel.type == .new ? "Register succesfully" : "Update successfully", handler: nil)
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func deleteRegistration() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.deleteRegistration { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.alert(msg: "Detele successfully", handler: { _ in
                        this.popViewController()
                    })
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - IBActions
    @IBAction private func confirmRegister(_ sender: Any) {
        registerVaccine()
    }

    @IBAction func deleteRegistration(_ sender: UIButton) {
        deleteRegistration()
    }

    // MARK: - Objc func
    @objc private func popToHome() {
        guard let navigationController = navigationController else { return }
        for controller in navigationController.viewControllers where controller is HomeViewController {
            navigationController.popToViewController(controller, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension RegisterInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel, let type = RegistrationType(rawValue: indexPath.row) else { return UITableViewCell() }
        if type == .time {
            let cell = tableView.dequeue(DatePickerCell.self)
            cell.delegate = self
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? DatePickerCellViewModel
            return cell
        }
        let cell = tableView.dequeue(RegisterInfoCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? RegisterInfoCellViewModel
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RegisterInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundConfiguration = .clear()
        guard let type = RegistrationType(rawValue: indexPath.row) else { return }
        switch type {
        case .medicalCenter:
            let vc = MedicalCenterViewController()
            vc.viewModel = MedicalCenterViewModel(medicalCenterName: viewModel?.registerInfo.medicalCenter?.name ?? "")
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

// MARK: - DatePickerCellDelegate

extension RegisterInfoViewController: DatePickerCellDelegate {
    func cell(_ cell: DatePickerCell, needPerformAction action: DatePickerCell.Action) {
        switch action {
        case .done(let value):
            guard let viewModel = viewModel else { return }
            viewModel.setDate(value: value)
        }
    }
}

// MARK: - MedicalCenterViewControllerDelegate
extension RegisterInfoViewController: MedicalCenterViewControllerDelegate {
    func controller(_ controller: MedicalCenterViewController, needPerformAction action: MedicalCenterViewController.Action) {
        switch action {
        case .updateMedicalCenter(let medicalCenter):
            viewModel?.setMedicalCenter(value: medicalCenter)
            tableView.reloadRows(at: [IndexPath(row: RegistrationType.medicalCenter.rawValue, section: 0)], with: .automatic)
        }
    }
}
