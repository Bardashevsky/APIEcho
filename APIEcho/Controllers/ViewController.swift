//
//  ViewController.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 09.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private let nameTextField = UITextField(tag: 0, returnButtonType: .next, placeHolder: "Enter your name...", isSecurity: false)
    private let emailTextField = UITextField(tag: 1, returnButtonType: .next, placeHolder: "Enter your email...", isSecurity: false)
    private let passwordTextField = UITextField(tag: 2, returnButtonType: .done, placeHolder: "Enter your password...", isSecurity: true)
    
    private let authSwitchSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Sign Up", "Sign In"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(authSwitchAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let authStackView: UIStackView = {
        let authStackView = UIStackView()
        authStackView.axis = .vertical
        authStackView.spacing = 10
        authStackView.alignment = .fill
        authStackView.translatesAutoresizingMaskIntoConstraints = false
        return authStackView
    }()
    
    private let signUpButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(signUpAction(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 5
        btn.setTitle("Sign Up", for: .normal)
        return btn
    }()
    
    private let signInButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(signInAction(_:)), for: .touchUpInside)
        btn.isHidden = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 5
        btn.setTitle("Sign In", for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Api echo"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupViews() {
        self.view.addSubview(authStackView)
        self.view.addSubview(authSwitchSegmentedControl)
        self.view.addSubview(signUpButton)
        self.view.addSubview(signInButton)
        
        authStackView.addArrangedSubview(nameTextField)
        authStackView.addArrangedSubview(emailTextField)
        authStackView.addArrangedSubview(passwordTextField)
        authStackView.addArrangedSubview(authSwitchSegmentedControl)
        authStackView.addArrangedSubview(signUpButton)
        authStackView.addArrangedSubview(signInButton)
        
        NSLayoutConstraint.activate([
            authStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40),
            authStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            authStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
        ])
    
    }
    
    //MARK: - Actions -
    @objc private func authSwitchAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.3) {
                self.signInButton.isHidden = true
                self.signUpButton.isHidden = false
                self.nameTextField.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.signInButton.isHidden = false
                self.signUpButton.isHidden = true
                self.nameTextField.isHidden = true
            }
        }
    }
    
    @objc private func signUpAction(_ sender: UIButton) {
        self.view.endEditing(true)
        sender.isUserInteractionEnabled = false
        AuthManager.shared.signUp(name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text) { (response) in
            DispatchQueue.main.async {
                sender.isUserInteractionEnabled = true
            }
            switch response {
            case .success(let response):
                if !response.errors.isEmpty {
                    DispatchQueue.main.async {
                        UIApplication.getTopViewController()?.showAlert(with: "Error", and: response.errors.first!.message ?? "Unknown Error")
                    }
                } else if let access_token = response.data.access_token {
                    DispatchQueue.main.async { [weak self] in
                        let vc = ListViewController(accessToken: access_token)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        UIApplication.getTopViewController()?.showAlert(with: "Error", and: "Invalid access_token")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    UIApplication.getTopViewController()?.showAlert(with: "Error", and: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func signInAction(_ sender: UIButton) {
        self.view.endEditing(true)
        sender.isUserInteractionEnabled = false
        AuthManager.shared.signIn(email: emailTextField.text, password: passwordTextField.text) { (response) in
            DispatchQueue.main.async {
                sender.isUserInteractionEnabled = true
            }
            switch response {
            case .success(let response):
                if !response.errors.isEmpty {
                    DispatchQueue.main.async {
                        UIApplication.getTopViewController()?.showAlert(with: "Error", and: response.errors.first!.message ?? "Unknown Error")
                    }
                } else if let access_token = response.data.access_token {
                    DispatchQueue.main.async { [weak self] in
                        let vc = ListViewController(accessToken: access_token)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        UIApplication.getTopViewController()?.showAlert(with: "Error", and: "Invalid access_token")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    UIApplication.getTopViewController()?.showAlert(with: "Error", and: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && authStackView.frame.maxY > (keyboardSize.minY + 16) {
                self.view.frame.origin.y -= authStackView.frame.maxY - keyboardSize.minY + 16
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

//MARK: - UITextFieldDelegate -
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var characterString = "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
        if textField.tag == emailTextField.tag {
            characterString.append("@.")
        }
        let set = NSCharacterSet(charactersIn: characterString).inverted
        
        return string.rangeOfCharacter(from: set) == nil
    }

}
