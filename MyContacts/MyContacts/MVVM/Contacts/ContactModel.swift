//
//  ContactModel.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/22/21.
//

import Foundation
import UIKit

enum ContactDetailType {
    
    case mainInfo
    case name
    case phone
    case email
    case postalAddress
    case organization
    case birthday
}

// Used Builder design pattern
class ContactBuilder {

    private var cellIdentifier:String = ""
    
    // contact main info
    private var givenName:String = ""
    private var phoneNumber:String = ""
    private var identifier:String = ""
    
    // contact details info
    private var familyName:String = ""
    private var organiazationName:String = ""
    private var birthday:String = ""
    private var postalAddress:String = ""
    private var email:String = ""
    private var image:UIImage?
    
    // MARK: Set methods
    func setGivenName(givenName:String) {

        self.givenName = givenName
    }
    
    func setFamilyName(familyName:String) {
        
        self.familyName = familyName
    }
    
    func setOrganiazationName(organiazationName:String) {
        
        self.organiazationName = organiazationName
    }
    
    func setBirthday(birthday:String) {
        
        self.birthday = birthday
    }
    
    func setPostalAddress(postalAddress:String) {
        
        self.postalAddress = postalAddress
    }
    
    func setPhoneNumber(phoneNumber:String) {
        
        self.phoneNumber = phoneNumber
    }
    
    func setIdentifier(identifier:String) {
        
        self.identifier = identifier
    }
        
    func setEmail(email:String) {
        
        self.email = email
    }
    
    func setImage(image:UIImage?) {
        
        self.image = image
    }
    
    // MARK: Builder method
    func buildObject(cellIdentifier:String, contactDetailType:ContactDetailType) -> ContactModel {
        
        return ContactModel(cellIdentifier: cellIdentifier,
                            contactDetailType:contactDetailType,
                            givenName: self.givenName,
                            phoneNumber: self.phoneNumber,
                            identifier: self.identifier,
                            familyName: self.familyName,
                            organiazationName: self.organiazationName,
                            birthday: self.birthday,
                            postalAddress: self.postalAddress,
                            email: self.email,
                            image: self.image)
    }
}

struct ContactModel:BaseModel {

    var cellIdentifier: String?
    var contactDetailType: ContactDetailType?
    
    // contact main info
    var givenName:String
    var phoneNumber:String
    var identifier:String
    
    // contact details info
    var familyName:String
    var organiazationName:String
    var birthday:String
    var postalAddress:String
    var email:String
    var image:UIImage?
}

extension ContactModel {
    
    var displayName:String {
        return givenName + " " + familyName
    }
    var displayNameFirstLetters:String {
        var result = ""
        if(givenName != "#") {
            let index = givenName.index(givenName.startIndex, offsetBy: 1)
            result = String(givenName.prefix(upTo: index))
        }
        if(!familyName.isEmpty) {
            let index = familyName.index(familyName.startIndex, offsetBy: 1)
            result += String(familyName.prefix(upTo: index))
        }
        return result
    }
}
