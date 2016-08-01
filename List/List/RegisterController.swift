//
//  RegisterController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 7/24/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//


import Foundation
import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {
    
    //values from register form
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var repeatPassword: UITextField!
    
    
    //activity indicator for when we attempt to log in
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //detect if there is an issue with a form
    func issueWithForm() -> Bool {
        
        return !(helper.isValidName(firstName.text!) && helper.isValidName(lastName.text!) && helper.isValidEmail(email.text!) && password.text! == repeatPassword.text! && helper.isValidPassword(password.text!));
    }
    
    @IBAction func register(sender: AnyObject) {
        
        if issueWithForm() {
            helper.displayAlert(self, title: "Error in form", message: "Please enter all details correctly")
        } else {
            
            //show activity indicator
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            //post parameters
            let parameters = "firstName=\(firstName.text!)&lastName=\(lastName.text!)&username=\(username.text!)&email=\(email.text!)&password=\(password.text!)"
            
            //url
            let url = NSURL(string: "https://list-backend-api.herokuapp.com/api/users")
            
            //create session object
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding);
            
        
            dispatch_async(dispatch_get_main_queue(), {
                
                let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    print("Response: \(response)")
                    let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    print("Body: \(strData)")
    
                    
                    //make sure to account for error
                    
                    do {
                        let jsonServerResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<String, AnyObject>
                        
                        let errmsg = jsonServerResponse["errmsg"] as? String
                        
                        if (errmsg == "Nil") {
                            //registration successful
                            let defaults = `NSUserDefaults`.standardUserDefaults()
                            
                            defaults.setObject(jsonServerResponse["user_id"]! as! String, forKey: "user_id")
                            defaults.synchronize()
                            
                            print("user registered")
                            self.performSegue("register")
                            
                        } else {
                            //sign up unsucessful: investigate the following!!!
                            helper.displayAlert(self, title: "Unable to Register", message: errmsg!)
                        }
                        
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                        helper.displayAlert(self, title: "Unable to Register", message: "Please try again later")
                    }
                    
                })
                
                task.resume()
            })
            
        }
    }
    
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
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.repeatPassword.delegate = self
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
