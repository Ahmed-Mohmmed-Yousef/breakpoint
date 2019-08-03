//
//  Group.swift
//  breakpoint
//
//  Created by Ahmed on 8/1/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import Foundation
class Group{
    private var _groupTitle: String
    private var _groupDesc: String
    private var _key: String
    private var _groupCount: Int
    private var _groupMembers: [String]
    
    var groupTitle: String{
        return _groupTitle
    }
    
    var groupDesc: String{
        return _groupDesc
    }
    
    var key: String{
        return _key
    }
    
    var groupCount: Int{
        return _groupCount
    }
    
    var groupMembers: [String]{
        return _groupMembers
    }
    
    init(groupTitle: String, groupDesc: String, key: String, groupCount: Int, groupMembers: [String]){
        self._groupTitle = groupTitle
        self._groupDesc = groupDesc
        self._groupMembers = groupMembers
        self._groupCount = groupCount
        self._key = key
    }
}
