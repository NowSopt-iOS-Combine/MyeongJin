//
//  NicknameViewController.swift
//  CombineStudy
//
//  Created by 이명진 on 5/10/24.
//

import UIKit
import Combine
import CombineCocoa

final class NicknameViewController: UIViewController {
    
    private let nameSubject: PassthroughSubject<String, Never> = .init()
    var namePublisher: AnyPublisher<String, Never> {
        return nameSubject.eraseToAnyPublisher()
    }
    
    private let validSubject: PassthroughSubject<Bool, Never> = .init()
    var validPublisher: AnyPublisher<Bool, Never> {
        return validSubject.eraseToAnyPublisher()
    }
    
    private var viewModel: NicknameViewModel
    private var cancelBag = CancelBag()
    
    
    // MARK: - UIComponents
    
    private let rootView = NicknameView()
    
    // MARK: - Life Cycles
    
    init(viewModel: NicknameViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        let input = NicknameViewModel.Input(
            nameTextField: rootView.nicknameTextField.textPublisher,
            saveButtonDidTap: rootView.saveButton.tapPublisher
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.nickNameModified
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] nickName in
                self?.nameSubject.send(nickName)
            }.store(in: cancelBag)
        
        output.saveButtonToggle
            .receive(on: RunLoop.main)
            .print()
            .sink { [weak self] valid in
                if valid {
                    self?.rootView.saveButton.isEnabled = valid
                    self?.rootView.saveButton.backgroundColor = .tvingRed
                } else {
                    self?.rootView.saveButton.isEnabled = valid
                    self?.rootView.saveButton.backgroundColor = .gray1
                }
            }.store(in: cancelBag)
    }
}
