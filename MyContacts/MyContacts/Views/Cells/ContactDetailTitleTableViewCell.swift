//
//  ContactDetailTitleTableViewCell.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/23/21.
//

import UIKit

class ContactDetailTitleTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func configureCell(item: BaseModel) {
        
        let model = item as! ContactDetailTitleModel
        
        titleLabel.text = model.detailName
    }
    
    override func prepareForReuse() {
        
        titleLabel.text = ""
    }
}
