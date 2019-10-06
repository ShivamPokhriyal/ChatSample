//
//  HomeViewModelTests.swift
//  ChatSampleTests
//
//  Created by Shivam Pokhriyal on 07/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import XCTest
@testable import ChatSample

class HomeViewModelTests: XCTest {

    func testRowsCount_WhenMessageListIsEmpty_isZero() {
        class MessageServiceMock: MessageDBService {
            override func getMessageList() -> [Message]? {
                return nil
            }
        }
        let viewModel = HomeViewModel()
        viewModel.messageService = MessageServiceMock()
        viewModel.prepareController()
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 0)
    }

    func testRowCount_WhenMessagesPresent_notZero() {
        class MessageServiceMock: MessageDBService {
            override func getMessageList() -> [Message]? {
                return [Message(message: nil, filePath: nil, type: 0, userId: "", id: "", time: 1)]
            }
        }
        let viewModel = HomeViewModel()
        viewModel.messageService = MessageServiceMock()
        viewModel.prepareController()
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 1)
    }

    func testRowCount_AfterSendingMessage_shouldIncrement() {
        class MessageServiceMock: MessageDBService {
            override func getMessageList() -> [Message]? {
                return nil
            }
        }
        let viewModel = HomeViewModel()
        viewModel.messageService = MessageServiceMock()
        viewModel.prepareController()
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 0)
        viewModel.addMessage(Message(message: nil, filePath: nil, type: 0, userId: "demoUser", id: "demo", time: 123))
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 1)
    }

}
