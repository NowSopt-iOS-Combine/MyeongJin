//
//  LoginState.swift
//  CombineStudy
//
//  Created by 이명진 on 5/9/24.
//

import UIKit

enum PasswordVisibility {
    case visible
    case hidden

    var icon: UIImage {
        switch self {
        case .visible:
            return UIImage(resource: .icEye)
        case .hidden:
            return UIImage(resource: .icEyeSlash)
        }
    }

    mutating func toggle() {
        self = (self == .visible) ? .hidden : .visible
    }
}

enum ButtonStyle {
    case enabled
    case disabled

    var backgroundColor: UIColor {
        switch self {
        case .enabled:
            return .tvingRed
        case .disabled:
            return .clear
        }
    }

    var titleColor: UIColor {
        switch self {
        case .enabled:
            return .white
        case .disabled:
            return .gray2
        }
    }
}

