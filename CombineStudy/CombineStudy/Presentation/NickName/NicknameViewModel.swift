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
        
        let nickNameModified = input.saveButtonDidTap // 탭하면 그 순간 부터 결합이 되어버려서 name이 바뀔때마다 계속 호출
            .combineLatest(nickNamePublisher)
            .map { _, name in name }
            .eraseToAnyPublisher()
        
        let togglePublisher: AnyPublisher<Bool, Never> = nickNamePublisher
            .map { $0.count > 2 }
            .eraseToAnyPublisher()

        return Output(
            nickNameModified: nickNameModified,
            saveButtonToggle: togglePublisher
        )
        
    }
    
}


