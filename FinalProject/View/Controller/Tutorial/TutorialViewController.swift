//
//  TutorialViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 05/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import SwiftUtils

final class TutorialViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var gradientBackgroundView: UIView!
    var scrollWidth: CGFloat = 0.0
    var scrollHeight: CGFloat = 0.0
    var viewModel: TutorialViewModel?

//    override open var shouldAutorotate: Bool {
//        return false
//    }

    override func viewDidLayoutSubviews() {
        scrollWidth = kScreenSize.width
//        scrollHeight = scrollView.frame.size.height - 90
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        setGradientBackground()
        addItem()
    }

    func addItem() {
        guard let viewModel = viewModel else { return }
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        for index in 0..<viewModel.numberOfPage() {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            let slide = UIView(frame: frame)
            let imageView = UIImageView(image: UIImage(named: viewModel.showImage(at: index)))
            imageView.frame = CGRect(x: 0, y: kScreenSize.height / 5, width: 300, height: 300)
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
            slide.addSubview(imageView)
            slide.addSubview(title)
            slide.addSubview(desc)
            scrollView.addSubview(slide)
        }
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(viewModel.numberOfPage()), height: 0)
        pageControl.numberOfPages = viewModel.numberOfPage()
        pageControl.currentPage = 0
    }

    func setGradientBackground() {
        guard let viewModel = viewModel else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenSize.width * CGFloat(viewModel.numberOfPage()), height: kScreenSize.height * CGFloat(viewModel.numberOfPage()))
        let colorTop = #colorLiteral(red: 1.00, green: 0.98, blue: 0.96, alpha: 1.00).cgColor
        let colorBottom = #colorLiteral(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        scrollView.layer.insertSublayer(gradientLayer, at: 0)
    }

    @IBAction func pageChanged(_ sender: Any) {
        guard let scrollView = scrollView else { return }
        scrollView.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage ?? 0)), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }

    func setIndiactorForCurrentPage() {
        guard let scrollView = scrollView else { return }
        let page = (scrollView.contentOffset.x) / scrollWidth
        pageControl?.currentPage = Int(page)
        scrollView.scrollRectToVisible(CGRect(x: page * scrollWidth, y: 0, width: scrollWidth, height: self.scrollView.frame.height), animated: true)
    }
}

extension TutorialViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }
}