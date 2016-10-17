//
//  RegisterController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade
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
    
    @IBAction func register(_ sender: AnyObject) {
        
        if issueWithForm() {
            helper.displayAlert(self, title: "Error in form", message: "Please enter all details correctly")
        } else {
            
            //show activity indicator
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            //post parameters
            let parameters = "firstName=\(firstName.text!)&lastName=\(lastName.text!)&username=\(username.text!)&email=\(email.text!)&password=\(password.text!)"
            
            //url
            let url = URL(string: "https://list-backend-api.herokuapp.com/api/users")
            
            //create session object
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "POST"
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = parameters.data(using: String.Encoding.utf8);
            
        
            DispatchQueue.main.async(execute: {
                
                let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    print("Response: \(response)")
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8)!
                    print("Body: \(strData)")
    
                    
                    //make sure to account for error
                    
                    do {
                        let jsonServerResponse = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, AnyObject>
                        
                        let errmsg = jsonServerResponse["errmsg"] as? String
                        
                        if (errmsg == "Nil") {
                            //registration successful
                            let defaults = UserDefaults.standard
                            
                            defaults.set(jsonServerResponse["user_id"]! as! String, forKey: "user_id")
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //perform segue
    func performSegue(_ identifier:String){
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}
