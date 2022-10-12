//
//  RegisterViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 07/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import DropDown

class RegisterViewController: ViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var birthdayTextField: UITextField!
    @IBOutlet private weak var genderTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    @IBOutlet private var multiRadioButton: [UIButton]! {
        didSet {
            multiRadioButton.forEach { (button) in
                button.setImage(#imageLiteral(resourceName: "circle_radio_unselected"), for: .normal)
                button.setImage(#imageLiteral(resourceName: "circle_radio_selected"), for: .selected)
            }
        }
    }
    private let datePicker = UIDatePicker()
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
//            birthdayTextField.resignFirstResponder()
    }

    private func configUI() {
        nameTextField.returnKeyType = .next
        addressTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        phoneNumberTextField.keyboardType = .asciiCapableNumberPad
        passwordTextField.returnKeyType = .done

        nameTextField.delegate = self
        birthdayTextField.delegate = self
        addressTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
    }

    @IBAction private func maleFemaleAction(_ sender: UIButton) {
        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }
        print(sender.tag)
    }

    @IBAction func testButton(_ sender: UIButton) {
        dropDown.dataSource = ["Tomato soup", "Mini burgers", "Onion rings", "Baked potato", "Salad"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
            }
    }

    func uncheck() {
        multiRadioButton.forEach { (button) in
            button.isSelected = false
        }
    }

    func register() {
        print("fffff")
    }

    @IBAction func backToSignInButtonTouchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Objc func
    @objc private func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @objc private func cancelDatePicker() {
        self.view.endEditing(true)
    }
}

// MARK: UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            birthdayTextField.becomeFirstResponder()
        }
        switch textField {
        case nameTextField:
            birthdayTextField.becomeFirstResponder()
        case birthdayTextField:
            addressTextField.becomeFirstResponder()
        case addressTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            phoneNumberTextField.becomeFirstResponder()
        case passwordTextField:
            register()
        default:
            break
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == birthdayTextField {
            showDatePicker()
        }
        return true
    }
}

extension UIButton {

    func checkboxAnimation(closure: @escaping () -> Void) {
        guard let image = self.imageView else { return }
        self.adjustsImageWhenHighlighted = false
        self.isHighlighted = false

        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                closure()
                image.transform = .identity
            }, completion: nil)
        }
    }
}
