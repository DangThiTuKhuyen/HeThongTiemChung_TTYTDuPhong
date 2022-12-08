//
//  CommonCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

// MARK: - CommonCellDataSource
protocol CommonCellDataSource: AnyObject {
    func updateCellProvince(_ cell: CommonCell) -> String
    func updateCellDistrict(_ cell: CommonCell) -> String
}

// MARK: - CommonCellDelegate
protocol CommonCellDelegate: AnyObject {
    func cell(_ cell: CommonCell, needPerformAction action: CommonCell.Action)
}

final class CommonCell: UITableViewCell {

    // MARK: - Enum
    enum Action {
        case done(value: String, type: RegisterProfileType)
    }
    // MARK: - IBOutlets
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var valueTextField: PaddingTextField!
    @IBOutlet private weak var leadingViewConstraint: NSLayoutConstraint!

    // MARK: - Properties
    var tableView = UITableView()
    private let datePicker = UIDatePicker()
    var viewModel: CommonCellViewModel? {
        didSet {
            updateCell()
        }
    }
    weak var dataSource: CommonCellDataSource?
    weak var delegate: CommonCellDelegate?

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.delegate = self
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = UIImage(named: "")
        iconImageView.isHidden = false
        valueTextField.isUserInteractionEnabled = false
    }

    // MARK: - Private func

    func updateUI() {
        checkToUpdateKeyboardStatus()
    }

    private func checkToUpdateKeyboardStatus() {
        guard let viewModel = viewModel, let type = viewModel.type else { return }
        switch type {
        case .name, .email:
            valueTextField.isUserInteractionEnabled = viewModel.isSelected
            if viewModel.isSelected {
                valueTextField.becomeFirstResponder()
                showKeyBoard(typeKeyBoard: .alphabet, typeCell: type)
            } else {
                valueTextField.resignFirstResponder()
            }
        case .phoneNumber, .identityCard:
            valueTextField.isUserInteractionEnabled = viewModel.isSelected
            if viewModel.isSelected {
                showKeyBoard(typeKeyBoard: .numberPad, typeCell: type)
                valueTextField.becomeFirstResponder()
            } else {
                valueTextField.resignFirstResponder()
            }
        default:
            break
        }
    }

    func updateValueTextField() {
        valueTextField.resignFirstResponder()
        guard let viewModel = viewModel else {
            return
        }
        delegate?.cell(self, needPerformAction: .done(value: valueTextField.text ?? "", type: viewModel.type ?? .gender))
    }

    private func updateCell() {
        guard let viewModel = viewModel, let type = viewModel.type else { return }
        switch type {
        case .province:
            valueTextField.isUserInteractionEnabled = false
            iconImageView.isHidden = false
            if let dataSource = dataSource {
                valueTextField.text = dataSource.updateCellProvince(self)
            }

        case .district:
            valueTextField.isUserInteractionEnabled = false
            leadingViewConstraint.constant = 45
            iconImageView.isHidden = true
            if let dataSource = dataSource {
                valueTextField.text = dataSource.updateCellDistrict(self)
            }
        case .name, .email, .phoneNumber, .birthday, .identityCard:
            valueTextField.text = viewModel.item?.value
        default:
            break
        }
        iconImageView.image = UIImage(named: viewModel.item?.image ?? "")
        valueTextField.placeholder = viewModel.item?.placeholder
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


    private func showKeyBoard(typeKeyBoard: UIKeyboardType, typeCell: RegisterProfileType) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()
        switch typeCell {
        case .name, .email, .phoneNumber, .identityCard:
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        default:
            break
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        valueTextField.inputAccessoryView = toolbar
        valueTextField.keyboardType = typeKeyBoard
        valueTextField.autocorrectionType = .no
    }

    // MARK: - Objc func
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        valueTextField.text = formatter.string(from: datePicker.date)
        delegate?.cell(self, needPerformAction: .done(value: valueTextField.text ?? "", type: .birthday))
        self.endEditing(true)
    }

    @objc private func cancelDatePicker() {
        self.endEditing(true)
    }

    @objc private func done() {
        guard let viewModel = viewModel, let type = viewModel.type else { return }
        delegate?.cell(self, needPerformAction: .done(value: valueTextField.text ?? "", type: type))
        self.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension CommonCell: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let viewModel = viewModel, let type = viewModel.type else { return false }
        switch type {
        case .name, .email:
            showKeyBoard(typeKeyBoard: .alphabet, typeCell: type)
        case .birthday:
            showDatePicker()
        case .province, .district:
            break
        case .phoneNumber, .identityCard:
            showKeyBoard(typeKeyBoard: .asciiCapableNumberPad, typeCell: type)
            
        case .gender:
            break
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        delegate?.cell(self, needsPerformAction: .valueChanged(valueString: nameTextField.string.trimmedAllWhitespacesAndNewlines))
        textField.resignFirstResponder()
        return true
    }
}

