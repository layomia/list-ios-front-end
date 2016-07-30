//
//  Helper.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 7/24/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    //display any alert
    func displayAlert(obj: AnyObject, title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //obj.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        obj.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func isValidName(testString: String) -> Bool {
        //expand on this
        return testString != ""
    }
    
    func isValidUsername(testString: String) -> Bool {
        //expand on this
        return testString != ""
    }
    
    func isValidEmail(testString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testString)
    }
    
    func isValidPassword(testString: String) -> Bool {
        //expand on this
        return testString != ""
    }

}