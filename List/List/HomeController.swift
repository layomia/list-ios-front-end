//
//  HomeController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade
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
    
    @IBAction func viewLists(_ sender: AnyObject) {
        self.performSegue("homeToLists")
    }
    
    @IBAction func cancelCreateList(_ sender: AnyObject) {
        setBeginState()
        self.view.endEditing(true)
    }
    
    @IBAction func proceed(_ sender: AnyObject) {
        setEnterFundsState()
        self.view.endEditing(true)
    }
    
    @IBAction func createList(_ sender: AnyObject) {
        setEnterNameState()
    }
    
    @IBAction func toNewList(_ sender: AnyObject) {
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //assign textField delegates
    func assignTextFieldDelegates() {
        self.listTitleBox.delegate = self
        self.moneyAmountBox.delegate = self
    }
    
    //hide keyboard when user hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //perform segue
    func performSegue(_ identifier:String){
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "fromCreateToNewList" {
            if let destinationVC = segue.destination as? CreateListController {
                print(segue.destination)
                destinationVC.listTitle = listTitleBox.text!
                destinationVC.fundsAllocated = Int(moneyAmountBox.text!)!
            }
        }
    }
    
    func setBeginState() {
        //hidden items
        cancelButton.isHidden = true
        proceedButton.isHidden = true
        listTitleBackgroundBox.isHidden = true
        listTitlePrompt.isHidden = true
        listTitleBox.isHidden = true
        moneyAmountBox.isHidden = true
        dollarSignImage.isHidden = true
        toNewListButton.isHidden = true
        fundsPrompt.isHidden = true
        
        //visible items
        backgroundFruits.isHidden = false
        createListPrompt.isHidden = false
        viewListsButton.isHidden = false
        createListButton.isHidden = false
    }
    
    func setEnterNameState() {
        //hidden items
        createListPrompt.isHidden = true
        viewListsButton.isHidden = true
        createListButton.isHidden = true
        moneyAmountBox.isHidden = true
        dollarSignImage.isHidden = true
        toNewListButton.isHidden = true
        fundsPrompt.isHidden = true
        
        //visible items
        cancelButton.isHidden = false
        proceedButton.isHidden = false
        listTitleBackgroundBox.isHidden = false
        listTitlePrompt.isHidden = false
        listTitleBox.isHidden = false
        backgroundFruits.isHidden = false
    }
    
    func setEnterFundsState() {
        //hidden items
        createListPrompt.isHidden = true
        viewListsButton.isHidden = true
        createListButton.isHidden = true
        listTitlePrompt.isHidden = true
        listTitleBox.isHidden = true
        backgroundFruits.isHidden = true
        proceedButton.isHidden = true
        
        //visible items
        cancelButton.isHidden = false
        listTitleBackgroundBox.isHidden = false
        moneyAmountBox.isHidden = false
        dollarSignImage.isHidden = false
        toNewListButton.isHidden = false
        fundsPrompt.isHidden = false
    }
}
