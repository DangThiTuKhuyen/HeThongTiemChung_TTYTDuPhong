//
//  RegisterVaccineViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import SwiftUtils

final class RegisterVaccineViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var nameDiseaseLabel: UILabel!
    @IBOutlet private weak var describeLabel: UILabel!
    var viewModel: RegisterVaccineViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
    }

    private func configUI() {
        title = "Choose the vaccine"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        nextButton.isUserInteractionEnabled = false
        nextButton.alpha = 0.5
        guard let viewModel = viewModel else { return }
        nameDiseaseLabel.text = viewModel.diseaseName
        describeLabel.text = viewModel.diseaseDescribe
    }

    private func configCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.register(RegisterVaccineCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    @IBAction func nextButton(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        let vc = RegisterInfoViewController()
        vc.viewModel = RegisterInfoViewModel(registerInfo: viewModel.getTreatmentSelected(), diseaseName: viewModel.diseaseName, type: .new)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegisterVaccineViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRowInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(RegisterVaccineCollectionCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath, selected: viewModel.selectedIndexPath == indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nextButton.isUserInteractionEnabled = true
        nextButton.alpha = 1
        guard let viewModel = viewModel else { return }
        viewModel.selectedIndexPath = indexPath
        collectionView.reloadData()
    }
}

extension RegisterVaccineViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((kScreenSize.width - CGFloat(40)) / 2)
        return CGSize(width: width, height: 165)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
