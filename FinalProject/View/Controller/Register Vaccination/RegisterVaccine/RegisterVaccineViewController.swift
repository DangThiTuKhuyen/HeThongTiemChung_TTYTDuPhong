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

    var viewModel = RegisterVaccineViewModel()
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
    }

    private func configCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(RegisterVaccineCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        
    }
}

extension RegisterVaccineViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(RegisterVaccineCollectionCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath, selected: viewModel.selectedIndexPath == indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RegisterVaccineCollectionCell else { return }
        viewModel.selectedIndexPath = indexPath
        collectionView.reloadData()
    }
}

extension RegisterVaccineViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((kScreenSize.width - CGFloat(60)) / 2)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
