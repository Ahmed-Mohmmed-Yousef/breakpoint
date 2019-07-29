//
//  FeedCell.swift
//  breakpoint
//
//  Created by Ahmed on 7/29/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func setup(img: UIImage, email: String, msg: String){
        profileImg.image = img
        emailLbl.text = email
        contentLbl.text = msg
    }
}
