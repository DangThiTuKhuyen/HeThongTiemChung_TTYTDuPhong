//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/25/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import CoreLocation
import EventKit
import CoreImage
import SceneKit

// MARK: - Protocol
protocol HomeViewControllerDelegate: AnyObject {
    func controller(_ controller: HomeViewController, needPerformAction action: HomeViewController.Action)
}

final class HomeViewController: ViewController {

    // MARK: - Enum
    enum Action {
        case passIdDetail(id: String)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var realTime: UILabel!
    @IBOutlet private weak var QRImageView: UIImageView!
    @IBOutlet private weak var registerVaccineButton: UIButton!

    // MARK: - Properties
    var viewModel: HomeViewModel?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.items?[1].badgeValue = "1900"
//        self.tabBar.items![1].badgealue = "7"
        configUI()
        getProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private func
    private func configUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 20
        subView.layer.cornerRadius = 20
        registerVaccineButton.layer.cornerRadius = 25
        guard let viewModel = viewModel else { return }
        realTime.text = viewModel.getCurrentDate()
        guard let qrURLImage = URL(string: "http://3.92.194.85:3210/users/0879a9a2-5f65-4476-b107-fea78da2fd69/histories")?.qrImage(using: .black) else { return }
        QRImageView.image = qrURLImage
    }

    private func getProfile() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getProfile { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    this.nameLabel.text = profile.name
                    this.avatarImageView.setImage(with: profile.image ?? "", placeholder: "user.pdf")
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func setupDataRecommend() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getRecommendVenues { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let city):
                    this.nameLabel.text = city
//                    this.tableView.reloadRows(at: [IndexPath(row: TypeRow.recommend.rawValue, section: Config.section)], with: .fade)
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    @IBAction func registerVaccineButton(_ sender: UIButton) {
        let registerDisaeseVC = RegisterDisaeseViewController()
        navigationController?.pushViewController(registerDisaeseVC, animated: true)
    }

    @IBAction func viewVaccineHistory(_ sender: UIButton) {
        let historyVC = HistoryViewController()
        historyVC.viewModel = HistoryViewModel()
        navigationController?.pushViewController(historyVC, animated: true)
    }

    @IBAction func viewApplicationRegister(_ sender: UIButton) {
        let vc = RegistrationViewController()
        vc.viewModel = RegistrationViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func viewApointment(_ sender: Any) {
        let vc = AppointmentViewController()
        vc.viewModel = AppointmentViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func goToProfile() {
        tabBarController?.selectedIndex = 2
    }
}

extension URL {

    /// Creates a QR code for the current URL in the given color.
    func qrImage(using color: UIColor, logo: UIImage? = nil) -> UIImage? {

        guard let tintedQRImage = qrImage?.tinted(using: color) else {
            return nil
        }

        guard let logo = logo?.cgImage else {
            return UIImage(ciImage: tintedQRImage)
        }

        guard let final = tintedQRImage.combined(with: CIImage(cgImage: logo)) else {
            return UIImage(ciImage: tintedQRImage)
        }

        return UIImage(ciImage: final)
    }

    /// Returns a black and white QR code for this URL.
    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let qrData = absoluteString.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")

        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
}

extension CIImage {
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }

    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }

        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }

    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }

    /// Applies the given color as a tint color.
    func tinted(using color: UIColor) -> CIImage? {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage

        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

        return filter.outputImage ?? nil
    }
}

extension CIImage {

    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage ?? nil
    }
}
