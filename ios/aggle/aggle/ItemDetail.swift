//
//  ItemDetail.swift
//  aggle
//
//  Created by Jose Lemus on 4/21/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ItemDetail: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var itemDescription: UITextField!
    
    @IBOutlet weak var itemPrice: UITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var itemImageView : UIImageView!
    
    
     let rootRef = Firebase(url:"https://aggle.firebaseio.com/")
     var tempUI = UIImage()
     var base64String = String()
     var zipCode = "10029"
    
    
    override func viewDidLoad() {
        
        let userID = rootRef.authData.uid
        if let object = (NSUserDefaults.standardUserDefaults().objectForKey(userID))?.valueForKey("ZipCode"){
            print("newwwwwwwwwwwwwwwwwwwwwWWWWWWWWWWWWWWWWWWWW is")
            print(object)
            self.zipCode = object as! String
            print(self.zipCode)
        }
        
        itemImageView.image = tempUI // this displays the image
        if (itemImageView.image != nil){
            base64Encode()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    func base64Encode(){
        let image : UIImage = itemImageView.image! as UIImage
        let imageData = UIImagePNGRepresentation(image)
        
        self.base64String = String(imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))
    }
    
    
    
    @IBAction func setItemDetails(sender: AnyObject) {
        
        descriptionLabel.text = itemDescription.text
        
        priceLabel.text = itemPrice.text
        updateDataBase(descriptionLabel.text!, price: priceLabel.text!)
    }
    
    
    func updateDataBase(description:String, price: String){
        let userDB_ref = rootRef.childByAppendingPath("UsersDB/" + rootRef.authData.uid)
        
        userDB_ref.observeSingleEventOfType(.Value, withBlock: {snapshot in
            print(snapshot.description)
            self.zipCode = snapshot.value.objectForKey("ZipCode") as! String
            print(self.zipCode)
        })
        
        let itemDescription = description
        let itemPrice = price
        let itemZipCode = self.zipCode
        let ownerID = rootRef.authData.uid
        let base64String = self.base64String
        let soldTo = "someone"
        
       
        
        let zipRef = rootRef.childByAppendingPath("ZipDB/" + self.zipCode).childByAutoId()
        let zipInfo = ["Description": itemDescription, "Price" : itemPrice, "ItemZipCode" : self.zipCode, "OwnerID" : ownerID, "base64Encoding" : base64String, "BuyerID" : soldTo]
        
        zipRef.setValue(zipInfo)
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
