//
//  CustomConnectView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol CustomConnectViewProtocol: class {
    var username: String? { get set }
    var password: String? { get set }
    
    func updateCredentials()
    
    func updateServerPicker(state: ServerPickerView.State, action: @escaping Action)
}

class CustomConnectView: UIView {
    private var viewModel: CustomConnectViewModelProtocol
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = NSLocalizedString("Username:", comment: "Username:")
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("VPN username", comment: "Username")
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.textContentType = .username
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var containerUsernameView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            usernameLabel,
            usernameTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = NSLocalizedString("Password:", comment: "Password:")
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.placeholder = NSLocalizedString("VPN password", comment: "password")
        textField.delegate = self
        return textField
    }()
    
    private lazy var saveCredentialsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "blank-check-box"), for: .normal)
        button.setTitle("Save credentials", for: .normal)
        button.setImage(UIImage(named: "black-check-box-with-white-check"), for: .selected)
        button.setTitle("Save credentials", for: .selected)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.contentEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        button.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(saveCredentialsTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerPasswordView: UIStackView = {
        let passwordDescriptionStackView = UIStackView()
        passwordDescriptionStackView.axis = .horizontal
        passwordDescriptionStackView.addArrangedSubview(passwordLabel)
        passwordDescriptionStackView.addArrangedSubview(UIView())
        passwordDescriptionStackView.addArrangedSubview(saveCredentialsButton)
        
        let stackView = UIStackView(arrangedSubviews: [
            passwordDescriptionStackView,
            passwordTextField
        ])
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var containerCredentialsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            containerUsernameView,
            containerPasswordView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    // server picker
      
    private lazy var serverPickerView: ServerPickerView = {
        let view = ServerPickerView()
        return view
    }()
    
    private lazy var containerServerPickerView: UIView = {
        let view = UIView()
        view.addSubview(serverPickerView)
        serverPickerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
        }
        return view
    }()
    
    //
    
    private lazy var containerStackView: UIView = {
        let stackView = UIStackView(arrangedSubviews: [
            containerCredentialsStackView,
            containerServerPickerView
        ])
        stackView.axis = .vertical
        stackView.spacing = 32
        return stackView
            .contained(with: .init(top: 0, left: 16, bottom: 0, right: 16))
    }()
    
  
    
    init(viewModel: CustomConnectViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
        updateAll()
    }
    
    private func updateAll() {
        updateCredentials()
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    @objc private func saveCredentialsTouched() {
        viewModel.storeCredentials(!viewModel.credentialsIsStoring)
    }
    
    private func setupSubviews() {
        addSubview(containerStackView)
    }
    
    private func setupConstraints() {
        containerStackView.makeEdgesEqualToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CustomConnectView: CustomConnectViewProtocol {
    func updateServerPicker(state: ServerPickerView.State, action: @escaping Action) {
        serverPickerView.state = state
        serverPickerView.viewTappedAction = action
    }
    
    var username: String? {
        get {
            return usernameTextField.text
        }
        set {
            usernameTextField.text = newValue
        }
    }
    
    var password: String? {
        get {
            return passwordTextField.text
        }
        set {
            passwordTextField.text = newValue
        }
    }
    
    func updateCredentials() {
        saveCredentialsButton.isSelected = viewModel.credentialsIsStoring
        let credentials = try? viewModel.getCredentials()
        username = credentials?.username
        password = credentials?.password
    }
    
}

extension CustomConnectView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
