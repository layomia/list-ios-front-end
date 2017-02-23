//
//  ListTableViewCell.swift
//  List
//
//  Created by Oluwalayomi Akinrinade on 11/12/16.
//  Copyright © 2016 Oluwalayomi Akinrinade. All rights reserved.
//


import Foundation
import UIKit

class ListTableViewCell: UITableViewCell {
    
    // Properties
    var delegate: AllListsController!
    @IBOutlet var listName: UILabel!
    @IBOutlet var listImage: UIImageView!
    var listObject: List = List(name: "", description: "", groceries: [:], imgName: "", funds: 0)
    
    @IBAction func shopList(_ sender: Any) {
        // post parameters
        let listData = [
            "listItems": listObject.groceries
            ] as [String : Any]
        
        do {
            let parameters = try JSONSerialization.data(withJSONObject: listData, options: .prettyPrinted)
            
            // let url = URL(string: "http://localhost:8080/shop/list/")
            let url = URL(string: "https://list-backend-api.herokuapp.com/shop/list/")
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = parameters
            
            // DispatchQueue.main.async(execute: {
                let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    do {
                        let jsonServerResponse = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, AnyObject>
                        let errmsg = jsonServerResponse["errmsg"] as? String
                        
                        if (errmsg == nil) {
                            let data = jsonServerResponse["storesInfo"]!
                            self.delegate.performSegue(myData: data as AnyObject)
                        } else {
                            helper.displayAlert(self.delegate, title: "Unable to Shop List", message: "Please try again later")
                        }
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                        helper.displayAlert(self.delegate, title: "Unable Shop List", message: "Please try again later")
                    }
                })
                task.resume()
            // })
        } catch {
            print("Not able to convert your object to JSON")
            helper.displayAlert(self.delegate, title: "Unable to Shop List", message: "Please try again later")
        }
    }
    

    override func awakeFromNib() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}


