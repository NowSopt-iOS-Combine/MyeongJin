//
//  LoginViewModel.swift
//  CombineStudy
//
//  Created by 이명진 on 5/9/24.
//

import UIKit
import Combine

enum FocusType {
    case id, pw
}

final class LoginViewModel: ViewModelType {
    
    var cancelBag = CancelBag()
    
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    private let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
    
    struct Input {
        let loginTextField: AnyPublisher<String?, Never>
        let passTextField: AnyPublisher<String?, Never>
        let focusIdTextField: AnyPublisher<FocusType, Never>
        let focusPasswordTextField: AnyPublisher<FocusType, Never>
    }
    
    struct Output {
        let validate: AnyPublisher<Bool, Never>
        let focus: AnyPublisher<FocusType, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        
        let emailValidationPublisher = input.loginTextField
            .print()
            .map { $0 ?? "" }
            .map { $0.range(of: self.emailRegex, options: .regularExpression) != nil }
            .eraseToAnyPublisher()

        let passwordValidationPublisher = input.passTextField
            .print()
            .map { $0 ?? "" }
            .map { $0.range(of: self.passwordRegex, options: .regularExpression) != nil }
            .eraseToAnyPublisher()

        let isFormValidPublisher = Publishers.CombineLatest(emailValidationPublisher, passwordValidationPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
        
        let focusPublisher = Publishers.Merge(
            input.focusIdTextField,
            input.focusPasswordTextField
        )
            .eraseToAnyPublisher()
        
        return Output(validate: isFormValidPublisher, focus: focusPublisher)
            
    }
    
}

