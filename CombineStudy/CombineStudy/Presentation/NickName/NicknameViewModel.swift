//
//  NicknameViewModel.swift
//  CombineStudy
//
//  Created by 이명진 on 5/10/24.
//

import UIKit
import Combine

final class NicknameViewModel: ViewModelType {
    
    var cancelBag = CancelBag()
    
    struct Input {
        let nameTextField: AnyPublisher<String?, Never>
        let saveButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let nickNameModified: AnyPublisher<String, Never>
        let saveButtonToggle: AnyPublisher<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        
        let nickNamePublisher = input.nameTextField
            .map { $0 ?? "" }
            .eraseToAnyPublisher()
        
        let nickNameModified = input.saveButtonDidTap
            .combineLatest(nickNamePublisher)
            .map { _, name in name }
            .eraseToAnyPublisher()
        
        let togglePublisher: AnyPublisher<Bool, Never> = nickNamePublisher.map { $0.count > 1 }
            .eraseToAnyPublisher()

        return Output(
            nickNameModified: nickNameModified,
            saveButtonToggle: togglePublisher
        )
        
    }
    
}


