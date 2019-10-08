//
//  ContactViewModelTest.swift
//  ChatSampleTests
//
//  Created by Shivam Pokhriyal on 08/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import XCTest
@testable import ChatSample

class ContactViewModelTest: XCTest {

    func testFirstSectionTitle_ShouldBeFrequent() {
        let viewModel = ContactViewModel()
        viewModel.prepareController()
        XCTAssertEqual(viewModel.sectionFor(title: viewModel.frequentlyContactedValue), 0)
    }

    func testFrequentlyContactSectionTitle_ShouldChange() {
        let viewModel = ContactViewModel()
        viewModel.frequentlyContactedValue = "New title"
        viewModel.prepareController()
        XCTAssertEqual(viewModel.titleForSection(0), viewModel.frequentlyContactedValue)
    }

    func testSectionIndex_ShouldNotHaveFrequent() {
        let viewModel = ContactViewModel()
        viewModel.prepareController()
        let indices = viewModel.sectionIndexTitles()
        XCTAssertFalse(indices.contains(viewModel.frequentlyContactedKey))
        XCTAssertFalse(indices.contains(viewModel.frequentlyContactedValue))
    }

    func testNumberOfRows_WithWrongSection_ShouldReturnZero() {
        let viewModel = ContactViewModel()
        viewModel.prepareController()
        let count = viewModel.contactList.count
        XCTAssertEqual(viewModel.numberOfRows(in: count+10), 0)
    }

    func testNumberOfRows_WithCorrectSection_NotZero() {
        let viewModel = ContactViewModel()
        viewModel.prepareController()
        let count = viewModel.contactList.count
        XCTAssertNotEqual(viewModel.numberOfRows(in: count-1), 0)
    }

}
