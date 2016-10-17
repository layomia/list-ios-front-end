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
    
    @IBOutlet var listTitleLabel: UILabel!
    
    var listTitle = "";
    var fundsAllocated = 0
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //light formatting for table
        self.tableView.separatorStyle = .none
        
        //specifications for search functionality
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "+ add item to \(listTitle)"
        definesPresentationContext = true
        //self.view.insertSubview(searchController.searchBar, belowSubview: listTitleLabel)
        //self.view.addSubview(searchController.searchBar)
        tableView.tableHeaderView = searchController.searchBar
        
        // Do any additional setup after loading the view, typically from a nib
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            newListItemsController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? NewListItemsController
        }
        
        //configure behavior of menu button
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.revealViewController().rearViewRevealWidth = 300
        }
        
        //initialize grocery list. remember to move this to persistent storage. remember it has to be alphabetically ordered.
        groceries = [
            Grocery(id: "1", name: "Coffee", description: "You need this every morning.", categoryId: "1", imgName: "hamB"),
            Grocery(id: "2", name: "Tea", description: "Drink with jam and bread", categoryId: "1", imgName: "close_button"),
            Grocery(id: "3", name: "Sliced Bread", description: "Sliced bread is good for your soul", categoryId: "2", imgName: "healthy"),
            Grocery(id: "4", name: "Rolls", description: "Don't you like rolls?", categoryId: "2", imgName: "orange")
        ]
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
    
    //function for when is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            
        }
    }
    
}
