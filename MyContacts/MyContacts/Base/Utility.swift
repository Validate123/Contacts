//
//  Utility.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/23/21.
//

import Foundation
import Contacts

class Utility {
    
    static func isTextContainsOnlyNumbers(_ text:String) -> Bool {
        
        let regex = "[0-9]{1,20}"
        let result = NSPredicate(format:"SELF MATCHES %@", regex)
        return result.evaluate(with: text)
    }
    
    static func getContactsOrderType() -> ContactOrderType {
        
        let isAscending = UserDefaults.standard.integer(forKey: "Ascending")
        return ContactOrderType(rawValue: isAscending)!
    }
    
    static func setContactsOrderType(_ orderType:ContactOrderType) {
        
        UserDefaults.standard.set(orderType.rawValue, forKey: "Ascending")
        UserDefaults.standard.synchronize()
    }
    
    static func getDateFromDateComponent(_ dateComponent:DateComponents) -> String? {
        
        guard let date = Calendar.current.date(from: dateComponent) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    static func getContactGivenName(contact:CNContact) -> String? {
        
        var givenName:String? = "#"
        if contact.isKeyAvailable(CNContactGivenNameKey) {
            if(!contact.givenName.isEmpty) {
                givenName = contact.givenName
            }
        } else {
            givenName = nil
        }
        return givenName
    }
}

enum ContactOrderType:Int {
    
    case ascending
    case descending
}
