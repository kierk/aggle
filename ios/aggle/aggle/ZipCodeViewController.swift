//
//  ZipCodeViewController.swift
//  aggle
//
//  Created by Jose Lemus on 4/16/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import Foundation
import UIKit

class ZipCodeViewController : UIViewController { //Add Player view = Zip Code view
   
   @IBOutlet weak var zipCodeTextField: UITextField!

    // this function will send the user back after he clicks done. It will also send back the zipcode that he inputs
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("[In ZipCodeViewController/prepareForSegue] hi")
        
        let temp = self.zipCodeTextField.text // temp stores the zipcode entered by user in the box
        if segue.identifier == "SaveZipCode" {
            
            // this makes a variable called DestViewController which is a ViewController object.
            // It then sets the mainzipCode member variable for the created instance and sends it back to view 
            // controller
            var DestViewController : ViewController = segue.destinationViewController as! ViewController
            DestViewController.mainZipCode = temp!
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLoad() {
        
    }
    
    
    
    
    
}