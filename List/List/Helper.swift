//
//  Helper.swift
//  List
//
//  Created by Oluwalayomi Akinrinade
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    //display any alert
    func displayAlert(_ obj: AnyObject, title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            //obj.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        obj.present(alert, animated: true, completion: nil)
        
    }
    
    func isValidName(_ testString: String) -> Bool {
        //expand on this
        return testString != ""
    }
    
    func isValidUsername(_ testString: String) -> Bool {
        //expand on this
        return testString != ""
    }
    
    func isValidEmail(_ testString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testString)
    }
    
    func isValidPassword(_ testString: String) -> Bool {
        //expand on this
        return testString != ""
    }

}
