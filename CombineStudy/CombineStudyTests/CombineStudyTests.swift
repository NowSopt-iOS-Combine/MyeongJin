//
//  CombineStudyTests.swift
//  CombineStudyTests
//
//  Created by 이명진 on 5/9/24.
//

import XCTest
import Combine
@testable import CombineStudy

final class CombineStudyTests: XCTestCase {
    
    var viewModel: NicknameViewModel!
    var cancelBag: CancelBag!
    private var nameTextFieldSubject = PassthroughSubject<String?, Never>()
    private var saveButtonDidTapSubject = PassthroughSubject<Void, Never>()
    private var outputs: [String] = []
    private var toggles: [Bool] = []
    
    override func setUpWithError() throws {
        viewModel = NicknameViewModel()
        cancelBag = CancelBag()
        
        let output = viewModel.transform(
            from: .init(
                nameTextField: nameTextFieldSubject.eraseToAnyPublisher(),
                saveButtonDidTap: saveButtonDidTapSubject.eraseToAnyPublisher()
            ),
            cancelBag: cancelBag
        )
        output.nickNameModified
            .sink { [weak self] in
                self?.outputs.append($0)
            }
            .store(in: cancelBag)
        
        output.saveButtonToggle
            .sink { [weak self] toggle in
                self?.toggles.append(toggle)
            }
            .store(in: cancelBag)
    }
    
    override func tearDown() {
        viewModel = nil
        cancelBag = nil
        super.tearDown()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNicknameModified_WhenTextFieldChangesAndSaveButtonTapped() {
        // 시뮬레이션: 텍스트 필드 변경 후 저장 버튼 클릭
        nameTextFieldSubject.send("명진")
        nameTextFieldSubject.send("테스트코드")
        saveButtonDidTapSubject.send()
        
        XCTAssertEqual(outputs, ["테스트코드"], "저장하기 누르면 스트림 하나만 !")
        
        nameTextFieldSubject.send("A")  // 글자 수 1
        XCTAssertEqual(toggles.last, false, "Toggle should be false for less than 2 characters.")
        
        nameTextFieldSubject.send("AB")  // 글자 수 2
        XCTAssertEqual(toggles.last, true, "Toggle should be true for 2 or more characters.")
        
        nameTextFieldSubject.send("ABC")  // 글자 수 3
        XCTAssertEqual(toggles.last, true, "Toggle should remain true for 3 characters.")
        
    }
}
