//
//  ListCreationSplitController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 8/16/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation

class ListCreationSplitController: UISplitViewController, UISplitViewControllerDelegate {
    var listTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool{
        return true
    }
    
}