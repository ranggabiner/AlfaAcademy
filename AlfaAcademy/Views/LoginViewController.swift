//
//  LoginViewController.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import UIKit

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let usernameTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.grayBorder.cgColor
        field.layer.cornerRadius = 8
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.heightAnchor.constraint(equalToConstant: 55).isActive = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.backgroundColor = .grayLightClr
        field.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayHint]
        )
        return field
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.grayBorder.cgColor
        field.layer.cornerRadius = 8
        field.isSecureTextEntry = true
        field.heightAnchor.constraint(equalToConstant: 55).isActive = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.backgroundColor = .grayLightClr
        field.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayHint]
        )
        
        let showPasswordButton = UIButton(type: .custom)
        showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        showPasswordButton.tintColor = .gray
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
        rightPaddingView.addSubview(showPasswordButton)
        showPasswordButton.center = rightPaddingView.center
        
        field.rightView = rightPaddingView
        field.rightViewMode = .always
        
        return field
    }()
    private let usernameErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .blueClr
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let redBox: UIView = {
        let view = UIView()
        view.backgroundColor = .redClr
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Input username and password to login into Alfa Academy"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let doneSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtitle Text"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDoneButton()
        setupTextFieldObservers()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(redBox)
        redBox.addSubview(titleLabel)
        redBox.addSubview(subtitleLabel)
        view.addSubview(stackView)
        view.addSubview(loginButton)
        
        let usernameStackView = UIStackView(arrangedSubviews: [usernameTextField, usernameErrorLabel])
        usernameStackView.axis = .vertical
        usernameStackView.spacing = 5
        
        let passwordStackView = UIStackView(arrangedSubviews: [passwordTextField, passwordErrorLabel])
        passwordStackView.axis = .vertical
        passwordStackView.spacing = 5
        
        stackView.addArrangedSubview(usernameStackView)
        stackView.addArrangedSubview(passwordStackView)
        
        NSLayoutConstraint.activate([
            redBox.topAnchor.constraint(equalTo: view.topAnchor),
            redBox.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redBox.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            redBox.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: redBox.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: redBox.leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: redBox.leadingAnchor, constant: 16),
            
            stackView.topAnchor.constraint(equalTo: redBox.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                        
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    private func setupDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let subtitleItem = UIBarButtonItem(customView: doneSubtitleLabel)
        let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexibleSpace1, subtitleItem, flexibleSpace2, doneButton], animated: false)
        
        usernameTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
    }
    
    private func setupTextFieldObservers() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        usernameTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }

    @objc private func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.blueBorder.cgColor
        if textField == usernameTextField {
            doneSubtitleLabel.text = "Username"
        } else if textField == passwordTextField {
            doneSubtitleLabel.text = "Password"
        }
    }

    @objc private func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.grayBorder.cgColor
    }


    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func loginTapped() {
        guard let username = usernameTextField.text,
                let password = passwordTextField.text else { return }
          
          var isValid = true
          
          if username.isEmpty {
              usernameTextField.layer.borderColor = UIColor.red.cgColor
              usernameErrorLabel.text = "Username must be filled"
              usernameErrorLabel.isHidden = false
              isValid = false
          } else {
              usernameTextField.layer.borderColor = UIColor.grayBorder.cgColor
              usernameErrorLabel.isHidden = true
          }
          
        if isValid {
            viewModel.login(username: username, password: password) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        let studentVC = StudentViewController()
                        let nav = UINavigationController(rootViewController: studentVC)
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Login Failed",
                                                      message: error.localizedDescription,
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
    }

}
