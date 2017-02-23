//
//  PricesController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 11/22/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation
import UIKit

/*
 protocol ListTableViewCellDelegator {
 func performSegue(myData dataobject: AnyObject)
 }
 */

class PricesController: UITableViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    var prices: Array<List> = []
    
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
    
    //Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as! PriceTableViewCell
        
        let store : List = prices[(indexPath as NSIndexPath).row]
        
        let image : UIImage = UIImage(named: store.imgName)!
        
        
        return cell
    }
    
    // function for when is tapped
    // this funcitonality assumes
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //Segues
    //perform segue
    func performSegue(_ identifier:String){
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
         if segue.identifier == "showAddedItems" {
         let defaults: UserDefaults = UserDefaults.standard
         defaults.set(selectedGroceries, forKey: "selectedGroceries")
         defaults.synchronize()
         }
         */
    }
    
}
