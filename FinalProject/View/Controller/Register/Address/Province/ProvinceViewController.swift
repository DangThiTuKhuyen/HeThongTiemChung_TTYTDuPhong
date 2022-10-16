//
//  AddressViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 14/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol ProvinceViewControllerDelegate: AnyObject {
    func controller(_ controller: ProvinceViewController, neesPerformAction action: ProvinceViewController.Action)
}

class ProvinceViewController: UIViewController {

    enum Action {
        case updateProvince(province: Address)
    }

    @IBOutlet weak var tableView: UITableView!
    var viewModel = ProvinceViewModel()
    weak var delegate: ProvinceViewControllerDelegate?
    var type: RegisterProfileType = .province

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        getProvince()
        configTableView()
        setupNavi()
    }
    
    private func getData() {
        if type == .province {
            getProvince()
        } else {
            viewModel.getDistricts()
        }
    }

    private func getProvince() {
        HUD.show()
        viewModel.getProvince { [weak self] result in
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

    private func configTableView() {
        tableView.register(ProvinceCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupNavi() {
        title = "Province"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(chooseProvince))
    }

    @objc private func chooseProvince() {
        delegate?.controller(self, neesPerformAction: .updateProvince(province: viewModel.getAddressSelected()))
        navigationController?.popViewController(animated: true)
    }
}

extension ProvinceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ProvinceCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

extension ProvinceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexPath = indexPath.row
    }
}
