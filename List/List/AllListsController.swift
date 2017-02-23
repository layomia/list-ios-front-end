//
//  AllListsController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation
import UIKit

protocol ListTableViewCellDelegator {
    func performSegue(myData dataobject: AnyObject);
    func deactivateScreen()
}

class AllListsController: UITableViewController, ListTableViewCellDelegator {

    @IBOutlet var menuButton: UIBarButtonItem!
    var lists = NSArray()
    
    var groceryLists: Array<List> = []
    
    //activity indicator for when we attempt to log in
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.revealViewController().rearViewRevealWidth = 300
        }
        
        loadLists()
        
        let tempList = List(name: "Healthy", description: "", groceries: ["2": ["3": true], "1": ["2": true]], imgName: "orange", funds: 24)
        
        let tempList1 = List(name: "Morning Stuff", description: "", groceries: ["2": ["4": true, "7": true, "5": true, "8": true, "3": true], "1": ["2": true]], imgName: "coffee", funds: 24)
    
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
        return groceryLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        
        let list : List = groceryLists[(indexPath as NSIndexPath).row]
        
        let image : UIImage = UIImage(named: list.imgName)!
        
        cell.listImage?.image = image
        cell.listName!.text = list.name
        cell.listObject = list
        
        cell.delegate = self
        
        return cell
    }
    
    // function for when is tapped
    // this funcitonality assumes
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    internal func performSegue(myData dataobject: AnyObject) {
        // try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegue(withIdentifier: "viewStoreRankings", sender:dataobject )
    }
    
    internal func deactivateScreen() {
        print("definitely shouldn't be working now!")
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewStoreRankings" {
            var nextView = segue.destination as! StoresController
            nextView.stores = sender! as! Array<Any>
        }
    }
    
    func loadLists() {
        let defaults: UserDefaults = UserDefaults.standard
        let usersID = defaults.object(forKey: "user_id") as! String
        
        // let url = URL(string: "http://localhost:8080/api/lists/\(usersID)/")
        let url = URL(string: "https://list-backend-api.herokuapp.com/api/lists/\(usersID)/")
        
        let req = NSMutableURLRequest(url: url!)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                do {
                    let lists = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<Dictionary<String, Any>>
                    self.updateGroceryLists(lists: lists)
                    self.tableView.reloadData()
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                }
            }
            
            }.resume()
    }
    
    func updateGroceryLists(lists: Array<Dictionary<String, Any>>) {
        groceryLists = []
        
        for list in lists {
            let name = list["name"]! as! String
            let description = list["description"] as! String
            let groceries = list["groceries"] as! [String:[String:Bool]]
            let imgName = list["imgName"] as! String
            let funds = list["funds"] as! Int
            
            let tempList = List(name: name, description: description, groceries: groceries, imgName: imgName, funds: funds)
            
            print(tempList.imgName)
            
            groceryLists.append(tempList)
        }
    }

    
}
