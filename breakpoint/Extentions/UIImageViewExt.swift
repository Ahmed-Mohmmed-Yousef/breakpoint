//
//  UIImageViewExt.swift
//  breakpoint
//
//  Created by Ahmed on 8/1/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

extension UIImageView{
    func addRoundedShadowBorder(){
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = frame.width / 2
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 8)
    }
    
}
