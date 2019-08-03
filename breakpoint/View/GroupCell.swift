//
//  GroupCell.swift
//  breakpoint
//
//  Created by Ahmed on 7/31/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    static let id = "GroupCell"
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var memberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(groupTitle: String, description: String, members: String){
        groupTitleLbl.text = groupTitle
        descriptionLbl.text = description
        memberLbl.text = members
        
    }
    

}
