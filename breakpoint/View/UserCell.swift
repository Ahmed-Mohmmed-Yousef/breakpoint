//
//  UserCell.swift
//  breakpoint
//
//  Created by Ahmed on 7/30/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    static let id = "UserCell"
    var shown = false
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    func setup(img: UIImage, email: String, isSelected: Bool){
        profileImg.image = img
        emailLbl.text = email
        if isSelected{
            checkImg.isHidden = false
        } else {
            checkImg.isHidden = true
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected{
            if shown == false{
                checkImg.isHidden = false
                shown = true
            } else {
                checkImg.isHidden = true
                shown = false
            }
        }
    }

}
