//
//  ContactDetailTableViewCell.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/23/21.
//

import UIKit

class ContactDetailTableViewCell: BaseTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func configureCell(item: BaseModel) {
        
        let model = item as! ContactModel
        switch model.contactDetailType {
        case .mainInfo:
            break
        case .name:
            nameLabel.text = model.givenName
        case .phone:
            nameLabel.text = model.phoneNumber
            nameLabel.textColor = .systemBlue
        case .email:
            nameLabel.text = model.email
            nameLabel.textColor = .systemBlue
        case .organization:
            nameLabel.text = model.organiazationName
        case .birthday:
            nameLabel.text = model.birthday
        case .postalAddress:
            nameLabel.text = model.postalAddress
        case .none:
            break
        }
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
    }
}
