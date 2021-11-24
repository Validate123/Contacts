//
//  TestContactDetailsViewModel.swift
//  MyContactsTests
//
//  Created by Karen Petrosyan on 11/24/21.
//

import XCTest
import Contacts
@testable import MyContacts

class TestContactDetailsViewModel: XCTestCase {

    var contactDetailsViewModel:ContactDetailsViewModel = ContactDetailsViewModel()
    var contact:CNContact! 
    
    override func setUpWithError() throws {
        
        createMockCNContact()
    }
    
    // MARK: Prepare for testing
    func createMockCNContact() {
        
        let mockContact = CNMutableContact()
        mockContact.givenName = "Adam"
        mockContact.familyName = "Smith"
        // adding phones
        let contactPhoneNumber1 = CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: "11111222222"))
        let contactPhoneNumber2 = CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: "22222233333"))
        mockContact.phoneNumbers = [contactPhoneNumber1, contactPhoneNumber2]
        
        // add emails
        let email1 = CNLabeledValue(label:"Work Email", value:"test@test.com" as NSString)
        let email2 = CNLabeledValue(label:"Work Email", value:"test@test.com" as NSString)
        mockContact.emailAddresses = [email1, email2]
        
        // add address
        let address = CNMutablePostalAddress()
        address.street = "Test Street"
        address.city = "Test City"
        address.state = "Test State"
        address.postalCode = "Test Postal Code"
        address.country = "Test Country"
        let home = CNLabeledValue<CNPostalAddress>(label:CNLabelHome, value:address)
        mockContact.postalAddresses = [home]
        
        // add organization name
        mockContact.organizationName = "Organization"
        
        // add birthday
        var birthday = DateComponents()
        birthday.day = 1
        birthday.month = 8
        birthday.year = 1990
        mockContact.birthday = birthday
        
        contact = mockContact
    }
    
    func testCreateContactMainInfo() {
        
        let contactModel:ContactModel = contactDetailsViewModel.createContactMainInfo(contact: contact)
        XCTAssertNotNil(contactModel)
    }
    
    func testCreateContactPhones() {
        
        let contactPhones = contactDetailsViewModel.createContactPhones(contact: contact)
        XCTAssertTrue(contactPhones.count > 0, "we should have non empty array")
    }
    
    func testCreateContactEmails() {
        
        let contactEmails = contactDetailsViewModel.createContactEmails(contact: contact)
        XCTAssertTrue(contactEmails.count > 0, "we should have non empty array")
    }
    
    func testCreateContactOrganizationName() {
        
        let organization = contactDetailsViewModel.createContactOrganizationName(contact: contact)
        XCTAssertTrue(organization.count > 0, "we should have non empty array")
    }
    
    func testCreateContactPostalAddresses() {
        
        let postalAddresses = contactDetailsViewModel.createContactPostalAddresses(contact: contact)
        XCTAssertTrue(postalAddresses.count > 0, "we should have non empty array")
    }
    
    func testCreateContactBirthday() {
        
        let birthday = contactDetailsViewModel.createContactBirthday(contact: contact)
        XCTAssertTrue(birthday.count > 0, "we should have non empty array")
    }

    override func tearDownWithError() throws {
        
    }
}
