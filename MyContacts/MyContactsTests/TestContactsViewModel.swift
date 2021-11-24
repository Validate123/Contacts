//
//  TestContactsViewModel.swift
//  MyContactsTests
//
//  Created by Karen Petrosyan on 11/24/21.
//

import XCTest
import Contacts
@testable import MyContacts

class TestContactsViewModel: XCTestCase {

    var contactsViewModel:ContactsViewModel = ContactsViewModel()
    var contacts:[CNContact] = []
    
    override func setUpWithError() throws {
        
        createMockCNContacts()
        creatMockContactModels()
    }
    
    // MARK: Prepare for testing
    func createMockCNContacts() {
        
        let contact1 = CNMutableContact()
        contact1.givenName = "Adam"
        contact1.familyName = "Smith"
        let contact1PhoneNumber = CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: "11111222222"))
        contact1.phoneNumbers.append(contact1PhoneNumber)
        contacts.append(contact1)
        
        let contact2 = CNMutableContact()
        contact2.givenName = "Zevs"
        contact2.familyName = "Greek"
        let contact2PhoneNumber = CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: "333333444444"))
        contact2.phoneNumbers.append(contact2PhoneNumber)
        contacts.append(contact2)
    }
    
    func creatMockContactModels() {
        
        var arrayContacts:[ContactModel] = []
        for contact in contacts {
            
            if let model = contactsViewModel.createContactModel(contact: contact) {
                arrayContacts.append(model)
            }
        }
        contactsViewModel.contacts = arrayContacts
    }
    
    // MARK: Test methods
    func testCreateContactModel () {
        
        let contact = contacts[0]
        let contactModel = contactsViewModel.createContactModel(contact: contact)
        XCTAssertNotNil(contactModel)
    }
    
    func testSortingContacts() {
        
        var contactModel1:ContactModel!
        var contactModel2:ContactModel!
        
        contactsViewModel.sortContactsWith(.ascending)
        contactModel1 = contactsViewModel.contacts[0]
        contactModel2 = contactsViewModel.contacts[1]
        XCTAssertEqual(contactModel1.givenName, "Adam")
        XCTAssertEqual(contactModel2.givenName, "Zevs")
        
        contactsViewModel.sortContactsWith(.descending)
        contactModel1 = contactsViewModel.contacts[0]
        contactModel2 = contactsViewModel.contacts[1]
        XCTAssertEqual(contactModel1.givenName, "Zevs")
        XCTAssertEqual(contactModel2.givenName, "Adam")
    }
    
    func testFilterContactsWithSearchText() {
        
        var filteredContacts = contactsViewModel.filterContactsWithSearchText("Ad")
        if(filteredContacts.count > 0) {
            let contactModel:ContactModel = filteredContacts[0]
            XCTAssertEqual(contactModel.givenName, "Adam")
        }
        
        filteredContacts = contactsViewModel.filterContactsWithSearchText("333")
        if(filteredContacts.count > 0) {
            let contactModel:ContactModel = filteredContacts[0]
            XCTAssertEqual(contactModel.givenName, "Zevs")
        }
    }

    override func tearDownWithError() throws {
        
    }
}
