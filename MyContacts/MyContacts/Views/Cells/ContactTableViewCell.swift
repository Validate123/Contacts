//
//  ContactTableViewCell.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/22/21.
//

import UIKit

class ContactTableViewCell: BaseTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func configureCell(item: BaseModel) {
        
        let model = item as! ContactModel
        
        nameLabel.text = model.givenName
        phoneNumberLabel.text = model.phoneNumber
    }
    
    override func prepareForReuse() {
        
        nameLabel.text = ""
        phoneNumberLabel.text = ""
    }
}
