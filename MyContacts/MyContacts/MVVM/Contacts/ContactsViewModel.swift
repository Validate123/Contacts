//
//  ContactsViewModel.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/22/21.
//

import Foundation
import Contacts

class ContactsViewModel {
    
    var contacts : [ContactModel]! {
        didSet {
            DispatchQueue.main.async {
                self.bindViewModelToController()
            }
        }
    }
    var bindViewModelToController : (() -> ()) = {}
    
    func getContacts() {
        
        let backgroundThread = DispatchQueue.global(qos: .background)
        backgroundThread.async {
            let keys = [CNContactGivenNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keys)
            let contactStore = CNContactStore()
            do {
                request.sortOrder = CNContactSortOrder.givenName
                self.contacts = []
                try contactStore.enumerateContacts(with: request) { (contact, stop) in

                    if let modelContact = self.createContactModel(contact: contact) {
                        self.contacts.append(modelContact)
                    }
                }
                self.sortContactsWith(Utility.getContactsOrderType())
            }
            catch {
                print("unable to fetch contacts")
            }
        }
    }
    
    func setContactOrderType(_ orderType:ContactOrderType) {
        
        Utility.setContactsOrderType(orderType)
        sortContactsWith(orderType)
    }
    
    func filterContactsWithSearchText(_ searchText: String) -> [ContactModel] {
        
        var array:[ContactModel] = []
        if(Utility.isTextContainsOnlyNumbers(searchText)) {
            array = contacts.filter { $0.phoneNumber.contains(searchText) }
        } else {
            array = contacts.filter { $0.givenName.lowercased().contains(searchText.lowercased()) }
        }
        return array
    }
    
    func createContactModel(contact:CNContact) -> ContactModel? {
        
        if contact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if let phoneNumberValue = contact.phoneNumbers.first {
                let phoneNumber = phoneNumberValue.value.stringValue
                if(!phoneNumber.isEmpty) {
                    if let givenName:String = Utility.getContactGivenName(contact: contact) {
                        let contactBuilder = ContactBuilder()
                        contactBuilder.setIdentifier(identifier: contact.identifier)
                        contactBuilder.setGivenName(givenName: givenName)
                        contactBuilder.setPhoneNumber(phoneNumber: phoneNumber)
                        let contact = contactBuilder.buildObject(cellIdentifier: "contacts", contactDetailType: .name)
                        return contact
                    }
                }
            }
        }
        return nil
    }
    
    func sortContactsWith(_ orderType:ContactOrderType) {
        
        contacts.sort(by: { orderType == .ascending ? $0.givenName < $1.givenName : $0.givenName > $1.givenName })
    }
}
