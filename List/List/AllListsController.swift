//
//  AllListsController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 8/3/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation
import UIKit

class AllListsController: UITableViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.revealViewController().rearViewRevealWidth = 300
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}