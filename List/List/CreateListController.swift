//
//  CreateListController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation
import UIKit

extension CreateListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class CreateListController: UITableViewController{
    
    //Properties
    var newListItemsController: NewListItemsController? = nil
    var groceries = [Grocery]()
    var filteredGroceries = [Grocery]()
    var selectedGroceries: [String:[String:Bool]] = [:]
    
    @IBOutlet var listTitleLabel: UILabel!

    var listTitle : String = ""
    var fundsAllocated : Int = 0
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBAction func viewAddedItems(_ sender: Any) {
        performSegue("showAddedItems")
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib
        
        // load new list details
        let defaults: UserDefaults = UserDefaults.standard
        self.listTitle = defaults.object(forKey: "current_new_list_name") as! String
        self.fundsAllocated = defaults.object(forKey: "current_new_list_amount") as! Int
        
        defaults.set([:], forKey: "selectedGroceries")
        
        // light formatting for table
        self.tableView.separatorStyle = .none
        
        //specifications for search functionality
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "+ add item to \(self.listTitle)"
        definesPresentationContext = true
        //self.view.insertSubview(searchController.searchBar, belowSubview: listTitleLabel)
        //self.view.addSubview(searchController.searchBar)
        tableView.tableHeaderView = searchController.searchBar
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            newListItemsController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? NewListItemsController
        }
        
        // configure behavior of menu button
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 300
        }
        
        // initialize grocery list. remember to move this to persistent storage. remember it has to be alphabetically ordered.
        groceries = [
            Grocery(id: "1", name: "Coffee", description: "You need this every morning.", categoryId: "1", imgName: "coffee"),
            Grocery(id: "2", name: "Cornflakes", description: "Good with milk and sugar", categoryId: "1", imgName: "cornflakes"),
            Grocery(id: "3", name: "Canned Vegetables", description: "These are very healthy", categoryId: "2", imgName: "canned_vegetables"),
            // Grocery(id: "4", name: "Oranges", description: "High in citrus", categoryId: "2", imgName: "orange"),
            Grocery(id: "5", name: "Eggs", description: "Work well boiled or fried!", categoryId: "2", imgName: "eggs"),
            Grocery(id: "6", name: "Milk", description: "Too many uses for this one", categoryId: "2", imgName: "milk"),
            Grocery(id: "7", name: "Orange Juice", description: "Very delicious", categoryId: "2", imgName: "orange_juice"),
            Grocery(id: "8", name: "Spaghetti Sauce", description: "Aka marinara", categoryId: "2", imgName: "spagetti_sauce"),
            Grocery(id: "8", name: "Spaghetti", description: "There's a constant battle between this and rice.", categoryId: "2", imgName: "spaghetti")
        ]
        
        // initialize selectedGroceries
        if defaults.object(forKey: "selectedGroceries") != nil &&  (defaults.object(forKey: "selectedGroceries") as! [String:[String:Bool]]).count != 0 {
            selectedGroceries = defaults.object(forKey: "selectedGroceries") as! [String : [String : Bool]]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredGroceries.count
        }
        
        //return groceries.count
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroceryTableViewCell
        
        let grocery: Grocery
        if searchController.isActive && searchController.searchBar.text != "" {
            grocery = filteredGroceries[(indexPath as NSIndexPath).row]
        } else {
            grocery = groceries[(indexPath as NSIndexPath).row]
        }
        
        let image : UIImage = UIImage(named: grocery.imgName)!
        
        cell.pictureLabel?.image = image
        cell.titleLabel!.text = grocery.name
        
        return cell
    }
    
    // function for when is tapped
    // this funcitonality assumes
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = indexPath.row
        let categoryId = filteredGroceries[cell].categoryId
        let groceryId = filteredGroceries[cell].id
        
        if selectedGroceries[categoryId] != nil {
            if selectedGroceries[categoryId]![groceryId] == nil {
                selectedGroceries[categoryId]?[groceryId] = true
            } else {
                // display message to user that the element has already been selected
                // this is where I can implement functionality to toggle presence
            }
        } else {
            selectedGroceries[categoryId] = [groceryId:true]
            print(type(of: selectedGroceries[categoryId]))
        }
    }
    
    @IBAction func closeCreateList(_ sender: AnyObject) {
        //confirm that user wants to leave current page
        
        performSegue("fromNewListToCreate")
    }
    
    //Search Functionality
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredGroceries = groceries.filter { grocery in
            return grocery.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    //Segues
    //perform segue
    func performSegue(_ identifier:String){
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddedItems" {
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(selectedGroceries, forKey: "selectedGroceries")
            defaults.synchronize()
        }
    }
    
}
