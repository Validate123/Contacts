//
//  ContactMainInfoTableViewCell.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/23/21.
//

import UIKit

class ContactMainInfoTableViewCell: BaseTableViewCell {

    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var displayNameLettersLabel: UILabel!
    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
     
        profileImageContainerView.layer.masksToBounds = true
        profileImageContainerView.layer.cornerRadius = profileImageContainerView.frame.size.width/2
        profileImageContainerView.layer.borderColor = UIColor.systemBlue.cgColor
        profileImageContainerView.layer.borderWidth = 1.0
    }
    
    override func configureCell(item: BaseModel) {
        
        let model = item as! ContactModel
        
        displayNameLabel.text = model.displayName
        if(model.image != nil) {
            displayNameLettersLabel.isHidden = true
            profileImageView.image = model.image
        } else {
            profileImageView.isHidden = true
            displayNameLettersLabel.text = model.displayNameFirstLetters
        }
    }
    
    override func prepareForReuse() {
        
        displayNameLabel.text = ""
        displayNameLettersLabel.text = ""
        profileImageView.image = nil
    }
}
