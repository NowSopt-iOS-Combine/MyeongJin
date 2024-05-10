//
//  NicknameView.swift
//  CombineStudy
//
//  Created by 이명진 on 5/10/24.
//

import UIKit

import SnapKit
import Then

final class NicknameView: UIView {
    
    // MARK: - UIComponents
    
    private let nickName = UILabel().then {
        $0.text = "닉네임을 입력해 주세요"
        $0.font = .boldSystemFont(ofSize: 23)
    }
    
    lazy var nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요 최대 (10자)"
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .gray1
        $0.addLeftPadding(width: 25)
    }
    
    lazy var saveButton = ButtonFactory.tvingButtonFactory(title: "저장하기", backgroundColor: .gray)
    
    private var userNickName: String = ""
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        backgroundColor = .white
    }
    
    private func setHierarchy() {
        addSubviews(
            nickName,
            nicknameTextField,
            saveButton
        )
    }
    
    private func setLayout() {
        nickName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(21)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }
    
}

