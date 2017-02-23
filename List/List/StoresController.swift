//
//  StoresController.swift
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

class StoresController: UITableViewController, ListTableViewCellDelegator {
    // @IBOutlet var menuButton: UIBarButtonItem!
    
    var lists = NSArray()
    var stores: Array<Any> = []
    //activity indicator for when we attempt to log in
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib
       /*
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.revealViewController().rearViewRevealWidth = 300
        }*/
        
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
        return stores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreTableViewCell
        
        let store = stores[(indexPath as NSIndexPath).row] as! Dictionary<String, Any>
        
        let image : UIImage = UIImage(named: (store["imgName"]! as! String))!
        
        cell.storeImage?.image = image
        cell.storeName!.text = store["name"]! as! String
        cell.storePrice!.text = "$\(store["price"]! as! Int)"
        
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
    
    internal func performSegue(myData dataobject: AnyObject) {
        // try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegue(withIdentifier: "viewStorePrices", sender:dataobject )
    }
    
    internal func deactivateScreen() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
}
