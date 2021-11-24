//
//  ContactDetailsViewModel.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/23/21.
//

import Foundation
import Contacts
import UIKit

class ContactDetailsViewModel {
    
    private(set) var contactDetails: [BaseModel]! {
        didSet {
            DispatchQueue.main.async {
                self.bindViewModelToController()
            }
        }
    }
    var bindViewModelToController: (() -> ()) = {}
    
    func getContactDetailsWithIdentifier(_ identifier:String) {
        
        let predicate = CNContact.predicateForContacts(withIdentifiers: [identifier])
        let keys = [CNContactGivenNameKey as CNKeyDescriptor,
                    CNContactPhoneNumbersKey as CNKeyDescriptor,
                    CNContactFamilyNameKey as CNKeyDescriptor,
                    CNContactEmailAddressesKey as CNKeyDescriptor,
                    CNContactOrganizationNameKey as CNKeyDescriptor,
                    CNContactPostalAddressesKey as CNKeyDescriptor,
                    CNContactBirthdayKey as CNKeyDescriptor,
                    CNContactImageDataKey as CNKeyDescriptor,
                    CNContactImageDataAvailableKey  as CNKeyDescriptor]
        let backgroundThread = DispatchQueue.global(qos: .background)
        backgroundThread.async {
            var contacts = [CNContact]()
            let contactStore = CNContactStore()
            do {
                contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keys)
                if (contacts.count != 0) {
                    self.createContactDetailsFrom(contact: contacts[0])
                }
            }
            catch {
                print("unable to fetch contact with identifier - ", identifier)
            }
        }
    }
    
    private func createContactDetailsFrom(contact:CNContact) {
        
        var detailsArray:[BaseModel] = []
        
        let contactMainInfo = createContactMainInfo(contact: contact)
        detailsArray.append(contactMainInfo)
        
        let contactPhones = createContactPhones(contact: contact)
        detailsArray.append(contentsOf: contactPhones)
        
        let contactEmails = createContactEmails(contact: contact)
        detailsArray.append(contentsOf: contactEmails)
        
        let contactOrganization = createContactOrganizationName(contact: contact)
        if(contactOrganization.count > 0) {
            detailsArray.append(contentsOf: contactOrganization)
        }
        
        let contactBirthday = createContactBirthday(contact: contact)
        if(contactBirthday.count > 0) {
            detailsArray.append(contentsOf: contactBirthday)
        }
        
        let contactPostalAddresses = createContactPostalAddresses(contact: contact)
        if(contactPostalAddresses.count > 0) {
            detailsArray.append(contentsOf: contactPostalAddresses)
        }
        
        contactDetails = detailsArray
    }
    
    // creates contact main info
    func createContactMainInfo(contact:CNContact) -> ContactModel {
        
        let contactBuilder = ContactBuilder()
        if let givenName = Utility.getContactGivenName(contact: contact) {
            contactBuilder.setGivenName(givenName: givenName)
        }
        if(contact.imageData != nil) {
            contactBuilder.setImage(image: UIImage(data: contact.imageData!))
        }
        contactBuilder.setFamilyName(familyName: contact.familyName)
        let contactMainInfo = contactBuilder.buildObject(cellIdentifier: "contactMainInfo", contactDetailType: .mainInfo)
        return contactMainInfo
    }
    
    // creates contact phones array
    func createContactPhones(contact:CNContact) -> [BaseModel] {
        
        var detailsArray:[BaseModel] = []
        var isSectionFirstItem = true
        for phone in contact.phoneNumbers {
            if(!phone.value.stringValue.isEmpty) {
                let contactBuilder = ContactBuilder()
                contactBuilder.setPhoneNumber(phoneNumber: phone.value.stringValue)
                let contact = contactBuilder.buildObject(cellIdentifier: "contactDetailName", contactDetailType: .phone)
                if(isSectionFirstItem) {
                    let contactDetailModel = ContactDetailTitleModel(cellIdentifier: "contactDetailTitle", detailName: "Phones")
                    detailsArray.append(contactDetailModel)
                    isSectionFirstItem = false
                }
                detailsArray.append(contact)
            }
        }
        return detailsArray
    }
    
    // creates contact emails array
    func createContactEmails(contact:CNContact) -> [BaseModel] {
        
        var detailsArray:[BaseModel] = []
        var isSectionFirstItem = true
        for email in contact.emailAddresses {
            if(email.value.length > 0) {
                let contactBuilder = ContactBuilder()
                contactBuilder.setEmail(email: email.value as String)
                let contact = contactBuilder.buildObject(cellIdentifier: "contactDetailName", contactDetailType: .email)
                if(isSectionFirstItem) {
                    let contactDetailModel = ContactDetailTitleModel(cellIdentifier: "contactDetailTitle", detailName: "Emails")
                    detailsArray.append(contactDetailModel)
                    isSectionFirstItem = false
                }
                detailsArray.append(contact)
            }
        }
        return detailsArray
    }
    
    // creates contact organization
    func createContactOrganizationName(contact:CNContact) -> [BaseModel] {
        
        var detailsArray:[BaseModel] = []
        if(!contact.organizationName.isEmpty) {
            let contactDetailModel = ContactDetailTitleModel(cellIdentifier: "contactDetailTitle", detailName: "Organization")
            detailsArray.append(contactDetailModel)
            
            let contactBuilder = ContactBuilder()
            contactBuilder.setOrganiazationName(organiazationName: contact.organizationName)
            let contact = contactBuilder.buildObject(cellIdentifier: "contactDetailName", contactDetailType: .organization)
            detailsArray.append(contact)
        }
        return detailsArray
    }
    
    // creates contact emails array
    func createContactPostalAddresses(contact:CNContact) -> [BaseModel] {
        
        var detailsArray:[BaseModel] = []
        var isSectionFirstItem = true
        for address in contact.postalAddresses {
            var addressName:String = ""
            if(!address.value.street.isEmpty) {
                addressName += address.value.street
            }
            if(!address.value.city.isEmpty) {
                addressName += ", " + address.value.city
            }
            if(!address.value.state.isEmpty) {
                addressName += ", " + address.value.state
            }
            if(!address.value.postalCode.isEmpty) {
                addressName += ", " + address.value.postalCode
            }
            if(!address.value.country.isEmpty) {
                addressName += ", " + address.value.country
            }
            if(!addressName.isEmpty) {
                let contactBuilder = ContactBuilder()
                contactBuilder.setPostalAddress(postalAddress: addressName)
                let contact = contactBuilder.buildObject(cellIdentifier: "contactDetailName", contactDetailType: .postalAddress)
                if(isSectionFirstItem) {
                    let contactDetailModel = ContactDetailTitleModel(cellIdentifier: "contactDetailTitle", detailName: "Addresses")
                    detailsArray.append(contactDetailModel)
                    isSectionFirstItem = false
                }
                detailsArray.append(contact)
            }
        }
        return detailsArray
    }
    
    // creates contact birthday
    func createContactBirthday(contact:CNContact) -> [BaseModel] {
        
        var detailsArray:[BaseModel] = []
        if(contact.birthday != nil) {
            if let birthday:String = Utility.getDateFromDateComponent(contact.birthday!) {
                
                let contactDetailModel = ContactDetailTitleModel(cellIdentifier: "contactDetailTitle", detailName: "Birthday")
                detailsArray.append(contactDetailModel)
                
                let contactBuilder = ContactBuilder()
                contactBuilder.setBirthday(birthday: birthday)
                let contact = contactBuilder.buildObject(cellIdentifier: "contactDetailName", contactDetailType: .birthday)
                detailsArray.append(contact)
            }
        }
        return detailsArray
    }
}
