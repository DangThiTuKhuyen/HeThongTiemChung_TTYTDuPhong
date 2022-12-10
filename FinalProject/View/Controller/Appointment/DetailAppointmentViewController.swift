//
//  DetailAppointmentViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class DetailAppointmentViewController: UIViewController {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var diseaseLabel: UILabel!
    @IBOutlet private weak var vaccineLabel: UILabel!
    @IBOutlet private weak var doseLabel: UILabel!

    var viewModel: DetailAppointmentViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        navigationController?.isNavigationBarHidden = true
        guard let viewModel = viewModel else { return }
        dateLabel.text = viewModel.appointment.registrationTime
        placeLabel.text = viewModel.appointment.medicalCenter?.name
        diseaseLabel.text = viewModel.appointment.disease?.diseaseName
        vaccineLabel.text = viewModel.appointment.disease?.treatments?.first?.vaccine?.vaccineName
        doseLabel.text = viewModel.appointment.registrationDose?.toString()
    }
}
