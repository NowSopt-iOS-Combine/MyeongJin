//
//  LoginViewController.swift
//  CombineStudy
//
//  Created by 이명진 on 5/9/24.
//

import UIKit
import Combine
import CombineCocoa

final class LoginViewController: UIViewController {
    
    // MARK: - Property
    
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
        
        let idTextFieldFocus = rootView.idTextField.didBeginEditingPublisher
            .map { return FocusType.id }
            .eraseToAnyPublisher()
        
        let pwTextFieldFocus = rootView.passwordTextField.didBeginEditingPublisher
            .map { return FocusType.pw }
            .eraseToAnyPublisher()
        
        let input = LoginViewModel.Input(
            loginTextField: rootView.idTextField.textPublisher,
            passTextField: rootView.passwordTextField.textPublisher,
            focusIdTextField: idTextFieldFocus,
            focusPasswordTextField: pwTextFieldFocus
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.validate
            .print()
            .sink(receiveValue: { [unowned self] valid in
                self.updateButtonStyle(button: self.rootView.loginButton, enabled: valid)
            }).store(in: cancelBag)
        
        output.focus
            .receive(on: RunLoop.main)
            .sink { [unowned self] focusType in
                switch focusType {
                case .id:
                    self.focusTextField(rootView.idTextField)
                case .pw:
                    self.focusTextField(rootView.passwordTextField)
                }
            }.store(in: cancelBag)
    }
    
    // MARK: - @objc Function
    
    @objc
    private func pushToLoginSuccess() {
        print("WelcomeViewController 으로 이동 로직")
    }
    
    private func presentToNicknameBottomSheet() {
        
        let contentViewController = NicknameViewController(viewModel: NicknameViewModel())
        let vc = BottomSheetViewController(
            bottomType: .middle,
            contentViewController: contentViewController
        )
        
        contentViewController.namePublisher.sink { [weak self] name in
            if name.count > 2 {
                self?.rootView.exampleNameLabel.text = name
            }
            print(name)
        }.store(in: cancelBag)
        
        
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: false)
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
    
    private func focusTextField(_ textField: UITextField) {
        // Apply focus UI
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        
        // Reset other text fields
        [rootView.idTextField, rootView.passwordTextField].filter { $0 !== textField }.forEach { otherTextField in
            otherTextField.layer.borderWidth = 0
            otherTextField.layer.borderColor = nil
        }
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
        
        rootView.makeNickNameLabel.gesture(.tap())
            .sink { [weak self] _ in
                self?.presentToNicknameBottomSheet()
            }.store(in: cancelBag)
    }
    
    private func setDelegate() {
        rootView.idTextField.delegate = self
        rootView.passwordTextField.delegate = self
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
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
    
    //    // 해당 텍스트 필드 강조 코드
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        textField.layer.borderColor = UIColor.white.cgColor
    //        textField.layer.borderWidth = 1
    //    }
    //
    //    // 텍스트 필드 사용 끝나면
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        textField.layer.borderWidth = 0
    //        textField.layer.borderColor = nil
    //    }
    //
}
