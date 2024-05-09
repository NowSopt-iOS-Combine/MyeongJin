//
//  TextFieldFactory.swift
//  CombineStudy
//
//  Created by 이명진 on 5/9/24.
//

import UIKit

import Then

struct TextFieldFactory {
    static func loginTextFieldFactory(title: String) -> UITextField {
        return UITextField().then {
            $0.attributedPlaceholder = NSAttributedString(
                string: title,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 15),
                    .foregroundColor: UIColor.gray1
                ]
            )
            
            $0.addLeftPadding(width: 22)
            $0.layer.cornerRadius = 3
            $0.backgroundColor = .gray4
            $0.textColor = .white
        }
    }
}
