//
//  LoginView.swift
//  CombineStudy
//
//  Created by 이명진 on 5/9/24.
//

import UIKit

import SnapKit
import Then

final class LoginView: UIView {
    
    // MARK: - Property
    
    var userNickName: String = ""
    
    // MARK: - UIComponents
    
    private lazy var loginTitle = UILabel().then {
        $0.text = "TVING ID 로그인"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray1
    }
    
    lazy var idTextField = TextFieldFactory.loginTextFieldFactory(title: "아이디")
    
    lazy var passwordTextField = TextFieldFactory.loginTextFieldFactory(title: "비밀번호").then {
        $0.isSecureTextEntry = true
    }
    
    private lazy var vStackViewLogin = UIStackView(
        arrangedSubviews: [
            idTextField,
            passwordTextField
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 7
        $0.distribution = .fillEqually
    }
    
    lazy var loginButton = ButtonFactory.tvingButtonFactory(title: "로그인 하기", radius: 3).then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray4.cgColor
        $0.layer.cornerRadius = 3
    }
    
    private let idSearch = UILabel().then {
        $0.text = "아이디 찾기"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray2
    }
    
    private let dividerLabel = UILabel().then {
        $0.text = "|"
        $0.textColor = .gray4
    }
    
    private let passwordSearch = UILabel().then {
        $0.text = "비밀번호 찾기"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray2
    }
    
    lazy var allDeleteButton = UIButton().then {
        $0.setImage(UIImage(resource: .icCancel), for: .normal)
        $0.tintColor = .white
        $0.isHidden = true
    }
    
    lazy var togglePasswordButton = UIButton().then {
        $0.setImage(UIImage(resource: .icEyeSlash), for: .normal)
        $0.isHidden = true
    }
    
    private lazy var hStackViewInfoFirst = UIStackView(
        arrangedSubviews: [
            idSearch,
            dividerLabel,
            passwordSearch
        ]
    ).then {
        $0.spacing = 36
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    private let notAccountLabel = UILabel().then {
        $0.text = "아직 계정이 없으신가요?"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray3
    }
    
    let makeNickNameLabel = UILabel().then {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.gray2,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        
        $0.attributedText = NSAttributedString(
            string: "TVING ID 회원가입하기",
            attributes: attributes
        )
        
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var hStackViewInfoSecond = UIStackView(
        arrangedSubviews: [
            notAccountLabel,
            makeNickNameLabel
        ]
    ).then {
        $0.spacing = 8
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    // MARK: - init
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI & Layout
    
    private func setUI() {
        backgroundColor = .black
    }
    
    private func setHierarchy() {
        addSubviews(
            loginTitle,
            vStackViewLogin,
            allDeleteButton,
            togglePasswordButton,
            loginButton,
            hStackViewInfoFirst,
            hStackViewInfoSecond
        )
    }
    
    private func setLayout() {
        loginTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(4)
        }
        
        vStackViewLogin.snp.makeConstraints {
            $0.top.equalTo(self.loginTitle.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52 + 52 + 7)
        }
        
        allDeleteButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.top).offset(16)
            $0.trailing.equalTo(passwordTextField.snp.trailing).inset(56)
        }
        
        togglePasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.top).offset(16)
            $0.leading.equalTo(allDeleteButton.snp.trailing).offset(16)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(vStackViewLogin.snp.bottom).offset(21)
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        hStackViewInfoFirst.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(31)
            $0.height.equalTo(22)
            $0.horizontalEdges.equalToSuperview().inset(85)
        }
        
        hStackViewInfoSecond.snp.makeConstraints {
            $0.top.equalTo(hStackViewInfoFirst.snp.bottom).offset(31)
            $0.height.equalTo(22)
            $0.horizontalEdges.equalToSuperview().inset(51)
        }
    }
}

