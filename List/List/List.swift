//
//  List.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 11/12/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation

class List {
    var name : String
    var listDescription: String
    var groceries : [String:[String:Bool]]
    var imgName: String
    var funds: Int
    
    // add timestamps for when list was created, modified
    // var timeCreated
    // var timeLastModified
    
    required init(name: String, description: String, groceries: [String:[String:Bool]], imgName: String, funds: Int) {
        self.name = name
        self.listDescription = description
        self.groceries = groceries
        self.imgName = imgName
        self.funds = funds
    }
}
