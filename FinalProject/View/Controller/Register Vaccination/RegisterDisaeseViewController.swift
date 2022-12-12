//
//  RegisterDisaeseViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class RegisterDisaeseViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var noResultLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    var viewModel = RegisterDisaeseViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        getDisease()
        configTableView()
        configUI()
        configSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        searchBar.resignFirstResponder()
    }

    private func getDisease() {
        HUD.show()
        viewModel.getDisease { [weak self] result in
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

    private func updateUI() {
        let isShowTable = viewModel.isShowTableView()
        tableView.isHidden = !isShowTable
        noResultLabel.isHidden = isShowTable
        tableView.reloadData()
    }

    private func configUI() {
        noResultLabel.isHidden = true
        searchBar.layer.borderWidth = 0
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderColor = UIColor.clear.cgColor
        title = "Choose the disease"
    }

    private func configTableView() {
        tableView.register(RegisterDiseaseCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
    }

    private func configSearchBar() {
//        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }

    private func search(keyWord: String) {
        viewModel.search(keyWord: keyWord)
        updateUI()

    }
}

// MARK: - UITableViewDataSource
extension RegisterDisaeseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RegisterDiseaseCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RegisterDisaeseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RegisterVaccineViewController()
        vc.viewModel = RegisterVaccineViewModel(treatments: viewModel.getDisaeseSelected(at: indexPath), diseaseName: viewModel.getNameSelected(at: indexPath))
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension RegisterDisaeseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(keyWord: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(keyWord: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}
