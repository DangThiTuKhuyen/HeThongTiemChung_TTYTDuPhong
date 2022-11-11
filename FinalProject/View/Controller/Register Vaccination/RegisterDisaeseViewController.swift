//
//  RegisterDisaeseViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

class RegisterDisaeseViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    var viewModel = RegisterDisaeseViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
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


    private func configUI() {
        searchBar.layer.borderWidth = 0
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderColor = UIColor.clear.cgColor
        title = "Choose the disaese"
    }

    private func configTableView() {
        tableView.register(RegisterDisaeseCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
    }

    private func configSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }

    private func search(keyWord: String) {
        viewModel.search(keyWord: keyWord)
        tableView.reloadData()

    }

    @IBAction func doneSearchButton(_ sender: UIButton) {
        search(keyWord: searchBar.text ?? "")
            searchBar.resignFirstResponder()
    }
    @IBAction func nextToVaccinButton(_ sender: UIButton) {
        let registerVaccineVC = RegisterVaccineViewController()
        navigationController?.pushViewController(registerVaccineVC, animated: true)
    }

}

// MARK: - UITableViewDataSource
extension RegisterDisaeseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return viewModel?.numberOfRowInSection() ?? 0
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RegisterDisaeseCell.self)
        //        cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? CommonCellViewModel
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RegisterDisaeseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RegisterVaccineViewController()
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
