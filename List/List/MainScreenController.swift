//
//  MainScreenController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 7/30/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation

import UIKit

class MainScreenController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //assign textField Delegates
        assignTextFieldDelegates()
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
        /*self.firstName.delegate = self
        self.lastName.delegate = self
        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.repeatPassword.delegate = self*/
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
    
}