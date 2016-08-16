//
//  Grocery.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 8/16/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation

class Grocery {
    var id : String
    var name : String
    var description: String
    var categoryId: String
    var imgName: String
    
    init(id: String, name: String, description: String, categoryId: String, imgName: String) {
        self.id = id
        self.name = name
        self.description = description
        self.categoryId = categoryId
        self.imgName = imgName
    }
}