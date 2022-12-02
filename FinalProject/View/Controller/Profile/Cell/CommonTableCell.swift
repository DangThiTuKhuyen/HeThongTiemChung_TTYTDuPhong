//
//  CommonTableCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

// MARK: - CommonCellDataSource
protocol CommonTableCellDataSource: AnyObject {
    func updateCellProvince(_ cell: CommonTableCell) -> String
    func updateCellDistrict(_ cell: CommonTableCell) -> String
}

protocol CommonTableCellDelegate: AnyObject {

    func cell(_ cell: CommonTableCell, needsPerformAction action: CommonTableCell.Action)
}

final class CommonTableCell: UITableViewCell {

    enum Action {
        case valueChanged(valueString: String)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var forwardImageView: UIImageView!
    @IBOutlet weak var widthForwardImage: NSLayoutConstraint!

    private let datePicker = UIDatePicker()
    weak var delegate: CommonTableCellDelegate?
    weak var dataSource: CommonTableCellDataSource?
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.borderStyle = .none
        showDatePicker()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        contentView.backgroundColor = .clear
        valueTextField.isHidden = false
        widthForwardImage.constant = 15
//        titleLabel.textColor = UIColor(red: 0.96, green: 0.68, blue: 0.28, alpha: 1.00)
        titleLabel.textColor = .black
        valueTextField.inputView = .none
        valueTextField.inputAccessoryView = nil
        valueTextField.keyboardType = .asciiCapable
    }

    var viewModel: CommonTableCellViewModel? {
        didSet {
            updateView()
        }
    }

    private func updateView() {
        guard let viewModel = viewModel, let type = viewModel.type else { return }
        switch type {
        case .avatar:
            break
        case .name, .identityCard, .email:
            titleLabel.text = viewModel.item?.title
            valueTextField.text = viewModel.item?.value
            widthForwardImage.constant = 0
        case .numberPhone, .birthday:
            titleLabel.text = viewModel.item?.title
            valueTextField.text = viewModel.item?.value
//            valueTextField.isUserInteractionEnabled = false
        case .gender, .province, .district:
            titleLabel.text = viewModel.item?.title
            valueTextField.text = viewModel.item?.value
            valueTextField.isUserInteractionEnabled = false
        case .changePass:
            titleLabel.text = viewModel.item?.title
            valueTextField.isHidden = true
        case .logout:
            titleLabel.text = viewModel.item?.title
            titleLabel.textColor = .red
            valueTextField.isHidden = true
            widthForwardImage.constant = 0
        }
    }

    func updateUI() {
//        guard let viewModel = viewModel else { return }
//        nameContainerView.backgroundColor = viewModel.isSlelected ? Color.selectCellColor : .clear
        checkToUpdateKeyboardStatus()
    }

    private func checkToUpdateKeyboardStatus() {
        guard let viewModel = viewModel else { return }
        switch viewModel.type {
        case .numberPhone:
            valueTextField.keyboardType = .numberPad
            showKeyBoard()
        case .birthday:
            showKeyBoard()
//            if viewModel.isSelected {
//                showDatePicker()
////                valueTextField.inputView = datePicker
////                valueTextField.keyboardType = datePicker
//            } else {
//                valueTextField.resignFirstResponder()
////                self.inputViewController?.dismiss(animated: true)
//                self.endEditing(true)
//            }
        default:
            break
        }
    }

    private func showKeyBoard() {
        guard let viewModel = viewModel else { return }
        valueTextField.isUserInteractionEnabled = viewModel.isSelected
        if viewModel.isSelected {
            valueTextField.becomeFirstResponder()
        } else {
            valueTextField.resignFirstResponder()
        }
    }

    private func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        valueTextField.inputAccessoryView = toolbar
        valueTextField.inputView = datePicker
    }

    @objc private func cancelDatePicker() {
        self.endEditing(true)
    }

    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        valueTextField.text = formatter.string(from: datePicker.date)
//        delegate?.cell(self, needPerformAction: .done(value: valueTextField.text ?? "", type: .birthday))
        self.endEditing(true)
    }

    func updateValueTextField() {
        valueTextField.resignFirstResponder()
        delegate?.cell(self, needsPerformAction: .valueChanged(valueString: valueTextField.text ?? ""))
    }

}
