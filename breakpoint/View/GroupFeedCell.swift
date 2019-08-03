//
//  GroupFeedCell.swift
//  breakpoint
//
//  Created by Ahmed on 8/1/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {
    
    static let id = "GroupFeedCell"
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func setup(img: UIImage, email: String, content: String){
        profileImg.image = img
        emailLbl.text = email
        contentLbl.text = content
    }
    
}
