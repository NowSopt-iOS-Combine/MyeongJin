//
//  LoginViewController.swift
//  CombineStudy
//
//  Created by 이명진 on 5/9/24.
//

import UIKit
import CombineCocoa

final class LoginViewController: UIViewController {
    
    // MARK: - Property
    
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    private let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
    
    var userNickName: String = ""
    
    private var viewModel: LoginViewModel
    private var cancelBag = CancelBag()
    
    private var passwordVisibility: PasswordVisibility = .hidden
    
    // MARK: - UIComponents
    
    private let rootView = LoginView()
    
    // MARK: - Life Cycles
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setAddTarget()
        bind()
    }
    
    
    // MARK: - Bind
    
    private func bind() {
        let input = LoginViewModel.Input(
            loginTextField: rootView.idTextField.textPublisher,
            passTextField: rootView.passwordTextField.textPublisher
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.validate
            .print()
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: rootView.loginButton)
            .store(in: cancelBag)
    }
    
    // MARK: - @objc Function
    
    @objc
    private func pushToLoginSuccess() {
        print("WelcomeViewController 으로 이동 로직")
    }
    
    @objc
    private func presentToNicknameBottomSheet() {
        print("NickNameBottomSheetVC 이 나오는 로직")
    }
    
    
    @objc private func togglePasswordTapped() {
        passwordVisibility.toggle()
        rootView.passwordTextField.isSecureTextEntry = (passwordVisibility == .hidden)
        rootView.togglePasswordButton.setImage(passwordVisibility.icon, for: .normal)
    }
    
    @objc
    private func deletePasswordTapped() {
        rootView.passwordTextField.text = ""
        updateButtonEnable()
    }
    
    // MARK: - Methods
    
    private func updateButtonEnable() {
        let isPasswordFieldEmpty = rootView.passwordTextField.text?.isEmpty ?? true
        rootView.allDeleteButton.isHidden = isPasswordFieldEmpty
        rootView.togglePasswordButton.isHidden = isPasswordFieldEmpty
        
        updateButtonStyle(button: rootView.loginButton, enabled: !isPasswordFieldEmpty)
    }
    
    private func updateButtonStyle(button: UIButton, enabled: Bool) {
        let style = enabled ? ButtonStyle.enabled : ButtonStyle.disabled
        
        button.isEnabled = enabled
        button.backgroundColor = style.backgroundColor
        button.setTitleColor(style.titleColor, for: .normal)
    }
    
    private func setAddTarget() {
        rootView.loginButton.addTarget(self, action: #selector(pushToLoginSuccess), for: .touchUpInside)
        rootView.allDeleteButton.addTarget(self, action: #selector(deletePasswordTapped), for: .touchUpInside)
        rootView.togglePasswordButton.addTarget(self, action: #selector(togglePasswordTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentToNicknameBottomSheet))
        rootView.makeNickNameLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setDelegate() {
        rootView.idTextField.delegate = self
        rootView.passwordTextField.delegate = self
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //        validateAndToggleLoginButton()
        
        if textField == rootView.passwordTextField {
            if let text = textField.text, text.isEmpty {
                rootView.allDeleteButton.isHidden = true
                rootView.togglePasswordButton.isHidden = true
            } else {
                rootView.allDeleteButton.isHidden = false
                rootView.togglePasswordButton.isHidden = false
            }
        }
    }
    
    // 해당 텍스트 필드 강조 코드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
    }
    
    // 텍스트 필드 사용 끝나면
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = nil
    }
    
}

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .black
        }
        
        set {
            setTitleColor(newValue ? .white: .gray2, for: .normal)
            backgroundColor = newValue ? .tvingRed : .clear
            isEnabled = newValue
        }
    }
}

