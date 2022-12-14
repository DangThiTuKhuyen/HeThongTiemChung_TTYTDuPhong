//
//  TutorialViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 05/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import SwiftUtils

final class TutorialViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!

    // MARK: - Properties
    var currentPage: Int = 0
    var scrollWidth: CGFloat = 0.0
    var scrollHeight: CGFloat = 0.0
    var viewModel: TutorialViewModel?

    // MARK: - Life cycle
    override func viewDidLayoutSubviews() {
        scrollWidth = kScreenSize.width
        scrollHeight = kScreenSize.height
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        addItem()
    }

    // MARK: - Private func
    private func addItem() {
        guard let viewModel = viewModel else { return }
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        for index in 0..<viewModel.numberOfPage() {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            let slide = UIView(frame: frame)
            let imageView = UIImageView(image: UIImage(named: viewModel.showImage(at: index)))
            imageView.frame = CGRect(x: 0, y: kScreenSize.height / 6, width: 300, height: 300)
            imageView.contentMode = .scaleToFill
            imageView.center = CGPoint(x: scrollWidth / 2, y: kScreenSize.height / 5 + 150)

            let title = UILabel(frame: CGRect(x: 20, y: imageView.frame.maxY + 30, width: scrollWidth - 40, height: 45))
            title.textAlignment = .center
            title.numberOfLines = 1
            title.font = UIFont.boldSystemFont(ofSize: 26.0)
            title.text = viewModel.showTitle(at: index)

            let desc = UILabel(frame: CGRect(x: 40, y: title.frame.maxY + 20, width: scrollWidth - 80, height: 60))
            desc.textAlignment = .center
            desc.numberOfLines = 2
            desc.font = UIFont.systemFont(ofSize: 16.0, weight: .thin)
            desc.text = viewModel.showDescs(at: index)

            let nextButton = UIButton(frame: CGRect(x: 80, y: desc.frame.maxY + 20, width: scrollWidth - 160, height: 60))
            nextButton.frame = CGRect(x: 80, y: desc.frame.maxY + 20, width: scrollWidth - 160, height: 60)
            nextButton.setTitle(viewModel.showTitleOfButton(at: index), for: .normal)
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.titleLabel?.font = UIFont(name: "Helvetica Neue, Medium", size: 24.0)
            nextButton.titleLabel?.textAlignment = .center
            nextButton.backgroundColor = #colorLiteral(red: 0.96, green: 0.68, blue: 0.28, alpha: 1.00)
            nextButton.layer.cornerRadius = 30
            nextButton.tag = index

            nextButton.addTarget(self, action: #selector(nextPageButton(_:)), for: .touchUpInside)
            slide.addSubview(imageView)
            slide.addSubview(title)
            slide.addSubview(desc)
            slide.addSubview(nextButton)
            scrollView.addSubview(slide)
        }
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(viewModel.numberOfPage()), height: 0)
        pageControl.numberOfPages = viewModel.numberOfPage()
        pageControl.currentPage = 0
    }

    private func setIndiactorForCurrentPage() {
        guard let scrollView = scrollView else { return }
        let page = (scrollView.contentOffset.x) / scrollWidth
        pageControl?.currentPage = Int(page)
        currentPage = Int(page)
        scrollView.scrollRectToVisible(CGRect(x: page * scrollWidth, y: 0, width: scrollWidth, height: self.scrollView.frame.height), animated: true)
    }

    // MARK: - IBActions
    @IBAction func pageChanged(_ sender: Any) {
        guard let scrollView = scrollView else { return }
        scrollView.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage ?? 0)), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }

    @IBAction private func skipButtonTouchUpInside(_ sender: UIButton) {
        let loginVc = LoginViewController()
        let loginNaviC = UINavigationController(rootViewController: loginVc)
        loginNaviC.modalPresentationStyle = .fullScreen
        present(loginNaviC, animated: true)
    }

    // MARK: - Objc func
    @objc private func nextPageButton(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        guard let scrollView = scrollView else { return }
        switch currentPage {
        case 0..<viewModel.numberOfPage() - 1:
            currentPage += 1
            pageControl.currentPage = currentPage
            scrollView.setContentOffset(CGPoint(x: scrollWidth * CGFloat(currentPage), y: 0), animated: true)
        default:
            let loginVc = LoginViewController()
            let loginNaviC = UINavigationController(rootViewController: loginVc)
            loginNaviC.modalPresentationStyle = .fullScreen
            present(loginNaviC, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension TutorialViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }
}
