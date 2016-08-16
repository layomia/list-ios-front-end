//
//  HomeController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 7/30/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UIViewController, UITextFieldDelegate {
    
    var pageState = 0 //0: create prompt; 1: enter name of list prompt
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var proceedButton: UIButton!
    @IBOutlet var createListButton: UIButton!
    @IBOutlet var viewListsButton: UIButton!
    @IBOutlet var toNewListButton: UIButton!
    @IBOutlet var listTitleBackgroundBox: UIImageView!
    @IBOutlet var backgroundFruits: UIImageView!
    @IBOutlet var dollarSignImage: UIImageView!
    @IBOutlet var listTitlePrompt: UILabel!
    @IBOutlet var createListPrompt: UILabel!
    @IBOutlet var fundsPrompt: UILabel!
    @IBOutlet var listTitleBox: UITextField!
    @IBOutlet var moneyAmountBox: UITextField!
    
    @IBAction func viewLists(sender: AnyObject) {
        self.performSegue("homeToLists")
    }
    
    @IBAction func cancelCreateList(sender: AnyObject) {
        setBeginState()
        self.view.endEditing(true)
    }
    
    @IBAction func proceed(sender: AnyObject) {
        setEnterFundsState()
        self.view.endEditing(true)
    }
    
    @IBAction func createList(sender: AnyObject) {
        setEnterNameState()
    }
    
    @IBAction func toNewList(sender: AnyObject) {
        //perform segue
        self.view.endEditing(true)
        performSegue("fromCreateToNewList")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.revealViewController().rearViewRevealWidth = 300
        }
        setBeginState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //hide keyboard when user taps outside of keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //assign textField delegates
    func assignTextFieldDelegates() {
        self.listTitleBox.delegate = self
        self.moneyAmountBox.delegate = self
    }
    
    //hide keyboard when user hits return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //perform segue
    func performSegue(identifier:String){
        self.performSegueWithIdentifier(identifier, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "fromCreateToNewList" {
            if let destinationVC = segue.destinationViewController as? CreateListController {
                print(segue.destinationViewController)
                destinationVC.listTitle = listTitleBox.text!
                destinationVC.fundsAllocated = Int(moneyAmountBox.text!)!
            }
        }
    }
    
    func setBeginState() {
        //hidden items
        cancelButton.hidden = true
        proceedButton.hidden = true
        listTitleBackgroundBox.hidden = true
        listTitlePrompt.hidden = true
        listTitleBox.hidden = true
        moneyAmountBox.hidden = true
        dollarSignImage.hidden = true
        toNewListButton.hidden = true
        fundsPrompt.hidden = true
        
        //visible items
        backgroundFruits.hidden = false
        createListPrompt.hidden = false
        viewListsButton.hidden = false
        createListButton.hidden = false
    }
    
    func setEnterNameState() {
        //hidden items
        createListPrompt.hidden = true
        viewListsButton.hidden = true
        createListButton.hidden = true
        moneyAmountBox.hidden = true
        dollarSignImage.hidden = true
        toNewListButton.hidden = true
        fundsPrompt.hidden = true
        
        //visible items
        cancelButton.hidden = false
        proceedButton.hidden = false
        listTitleBackgroundBox.hidden = false
        listTitlePrompt.hidden = false
        listTitleBox.hidden = false
        backgroundFruits.hidden = false
    }
    
    func setEnterFundsState() {
        //hidden items
        createListPrompt.hidden = true
        viewListsButton.hidden = true
        createListButton.hidden = true
        listTitlePrompt.hidden = true
        listTitleBox.hidden = true
        backgroundFruits.hidden = true
        proceedButton.hidden = true
        
        //visible items
        cancelButton.hidden = false
        listTitleBackgroundBox.hidden = false
        moneyAmountBox.hidden = false
        dollarSignImage.hidden = false
        toNewListButton.hidden = false
        fundsPrompt.hidden = false
    }
}