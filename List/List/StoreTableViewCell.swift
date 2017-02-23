//
//  StoreTableViewCell.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 11/22/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation

class StoreTableViewCell: UITableViewCell {
    
    //Properties
    @IBOutlet var storeImage: UIImageView!
    @IBOutlet var storeName: UILabel!
    @IBOutlet var storePrice: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}
