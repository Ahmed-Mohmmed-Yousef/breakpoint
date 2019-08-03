//
//  Messege.swift
//  breakpoint
//
//  Created by Ahmed on 7/29/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import Foundation

class Messege {
    private var _content: String
    private var _senderId: String
    
    var content: String{
        return _content
    }
    var senderId: String{
        return _senderId
    }
    
    init(content: String, senderId: String){
        self._content = content
        self._senderId = senderId
    }
}
