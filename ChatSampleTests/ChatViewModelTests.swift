//
//  ChatViewModelTests.swift
//  ChatSampleTests
//
//  Created by Shivam Pokhriyal on 07/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import XCTest
@testable import ChatSample

class ChatViewModelTests: XCTest {

    func testRowsCount_WhenMessageListIsEmpty_isZero() {
        class MessageServiceMock: MessageDBService {
            override func getMessageList() -> [Message]? {
                return nil
            }
        }
        let viewModel = ChatDetailViewModel(userId: "demoUser")
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
        let viewModel = ChatDetailViewModel(userId: "demoUser")
        viewModel.messageService = MessageServiceMock()
        viewModel.prepareController()
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 1)
    }

    func testRowCount_AfterMessageSent_shouldIncreaseByTwo() {
        class MessageServiceMock: MessageDBService {
            override func getMessageList() -> [Message]? {
                return nil
            }
        }
        let viewModel = ChatDetailViewModel(userId: "demoUser")
        viewModel.messageService = MessageServiceMock()
        viewModel.prepareController()
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 0)
        viewModel.sendText("New message")
        sleep(3)
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 2)
    }

}
