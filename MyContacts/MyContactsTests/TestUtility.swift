//
//  TestUtility.swift
//  MyContactsTests
//
//  Created by Karen Petrosyan on 11/24/21.
//

import XCTest
import Contacts
@testable import MyContacts

class TestUtility: XCTestCase {

    override func setUpWithError() throws {
        
    }
    
    func testIsTextContainsOnlyNumbers() {
        
        let number = Utility.isTextContainsOnlyNumbers("1234")
        XCTAssertTrue(number)
        
        let letter = Utility.isTextContainsOnlyNumbers("abcd")
        XCTAssertFalse(letter)
    }
    
    func testGetContactsOrderType() {
        
        let orderType = Utility.getContactsOrderType()
        XCTAssertTrue(orderType == .ascending || orderType == .descending)
    }
    
    func testgetDateFromDateComponent() {
        
        let dateComponents = DateComponents(year: 1990, month: 10, day: 10)
        let date = Utility.getDateFromDateComponent(dateComponents)
        XCTAssertTrue(date == "Oct 10, 1990")
    }
    
    func testGetContactGivenName() {
        
        let contact = CNMutableContact()
        contact.givenName = "Adam"
        contact.familyName = "Smith"
        var givenName:String? = Utility.getContactGivenName(contact: contact)
        XCTAssertTrue(givenName == "Adam")
        
        contact.givenName = ""
        contact.familyName = "Smith"
        givenName = Utility.getContactGivenName(contact: contact)
        XCTAssertTrue(givenName == "#")
    }

    override func tearDownWithError() throws {
        
    }
}
