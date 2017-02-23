//
//  LoginController.swift
//  List
//
//  Created by Oluwalayomi Akinrinade
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation
import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
    }
    
    //activity indicator for when we attempt to log in
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //detect if there is an issue with a form
    func issueWithForm() -> Bool {
        
        return !(helper.isValidEmail(email.text!) && helper.isValidPassword(password.text!));
    }
    
    @IBAction func login(_ sender: AnyObject) {
        //create functions for these
        if issueWithForm() {
            helper.displayAlert(self, title: "Error in form", message: "Please enter all details correctly")
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            //post parameters
            let parameters = "email=\(email.text!)&password=\(password.text!)"
            
            //url
            let url = URL(string: "https://list-backend-api.herokuapp.com/api/authenticate_user")
            
            //create session object
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "POST"
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = parameters.data(using: String.Encoding.utf8);
            
            DispatchQueue.main.async(execute: {
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                    
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                    
                    do {
                        let jsonServerResponse = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, AnyObject>
                        
                        //login successful
                        if (jsonServerResponse["message"] == nil) {
                            let defaults = UserDefaults.standard
                            defaults.set(jsonServerResponse["_id"]! as! String, forKey: "user_id")
                            defaults.synchronize()
                            
                            // resume screen interactivity
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            OperationQueue.main.addOperation {
                                self.performSegue("login")
                            }
                            
                        } else {
                            //sign up unsucessful: investigate the following!!!
                            helper.displayAlert(self, title: "Unable to Register", message: jsonServerResponse["message"]! as! String)
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                        
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                        helper.displayAlert(self, title: "Unable to Register", message: "Please try again later")
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                })
                
                task.resume()

            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //assign textField delegates
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
        self.email.delegate = self
        self.password.delegate = self
    }
    
    //hide keyboard when user hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //perfrom segue
    func performSegue(_ identifier:String){
        self.performSegue(withIdentifier: identifier, sender: self)
    }

}
