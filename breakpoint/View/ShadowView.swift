//
//  ShadowView.swift
//  breakpoint
//
//  Created by Ahmed on 7/29/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 10
    }

}
