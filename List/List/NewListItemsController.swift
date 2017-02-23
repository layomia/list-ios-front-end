//
//  NewListItemsController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation

import UIKit

class NewListItemsController: UITableViewController {
    
    var selectedGroceries: [String:[String:Bool]] = [:]
    var groceries: Array<Array<String>> = []
    
    // activity indicator
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load user defaults
        let defaults: UserDefaults = UserDefaults.standard
        
        // initialize selectedGroceries
        if defaults.object(forKey: "selectedGroceries") != nil {
            selectedGroceries = defaults.object(forKey: "selectedGroceries") as! [String : [String : Bool]]
        }
        
        getGroceryIds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveNewList(_ sender: Any) {
        let defaults: UserDefaults = UserDefaults.standard
        
        defaults.set([:], forKey: "selectedGroceries")
        
        if selectedGroceries.count == 0 {
            helper.displayAlert(self, title: "Unable to Save", message: "Please add at least one element to your list.")
        } else {
            let listName = defaults.object(forKey: "current_new_list_name") as! String
            let listFunds = defaults.object(forKey: "current_new_list_amount") as! Int
            let usersID = defaults.object(forKey: "user_id") as! String
            let imgNames = ["coffee", "cornflakes", "canned_vegetables", "eggs", "milk", "orange_juice", "spagetti_sauce", "spaghetti"]
            let randomIndex = Int(arc4random_uniform(UInt32(imgNames.count)))
            
            let newList = List(name: listName, description: "", groceries: selectedGroceries, imgName: imgNames[randomIndex], funds: listFunds)
            
            //show activity indicator
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // post parameters
            let listData = [
                "user_id": usersID,
                "name": newList.name,
                "description":newList.listDescription,
                "groceries": newList.groceries,
                "imgName": newList.imgName,
                "funds": newList.funds
            ] as [String : Any]
            
            do {
                let parameters = try JSONSerialization.data(withJSONObject: listData, options: .prettyPrinted)
                //let url = URL(string: "http://localhost:8080/api/lists/")
                let url = URL(string: "https://list-backend-api.herokuapp.com/api/lists/")
                let session = URLSession.shared
                let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.httpBody = parameters
                
                DispatchQueue.main.async(execute: {
                    let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        print("Response: \(response)")
                        let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                        print("Body: \(strData)")
                        
                        do {
                            let jsonServerResponse = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, AnyObject>
                            let errmsg = jsonServerResponse["errmsg"] as? String
                            
                            if (errmsg == "Nil") {
                                print("list created")
                                self.performSegue("fromNewListToAllLists")
                            } else {
                                helper.displayAlert(self, title: "Unable to Create List", message: errmsg!)
                            }
                        } catch let error as NSError {
                            print("json error: \(error.localizedDescription)")
                            helper.displayAlert(self, title: "Unable Create List", message: "Please try again later")
                        }
                    })
                    
                    task.resume()
                })
            } catch {
                // print("Not able to convert your object to JSON")
                helper.displayAlert(self, title: "Unable to Create List", message: "Please try again later")
            }
        }
    }
    
    @IBAction func addMoreListItems(_ sender: Any) {
        // performSegue("addNewItems")
    }
    
    //Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCell", for: indexPath)
        let grocery = groceries[(indexPath as NSIndexPath).row]
        
        
        cell.textLabel?.text = grocery[0]
    
        return cell
    }
    
    // function for when is tapped
    // this funcitonality assumes
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // Segues
    // perform segue
    func performSegue(_ identifier:String){
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewItems" {
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(selectedGroceries, forKey: "selectedGroceries")
            defaults.synchronize()
        }
    }
    
    func getGroceryIds() {
        let groceryName = [["Coffee", "coffee"], ["Cornflakes", "cornflakes"], ["Canned Vegetables", "canned_vegetables"],
                           ["Oranges", "oranges"], ["Eggs", "eggs"], ["Milk", "milk"], ["Orange Juice", "orange_juice"],
                           ["Spaghetti Sauce", "spaghetti_sauce"], ["Spaghetti", "spaghetti"]]
        
        for category in selectedGroceries {
            let cat = category.1

            for grocery in cat {
                groceries.append(groceryName[Int(grocery.0)! - 1]);
            }
        }
    }
}
