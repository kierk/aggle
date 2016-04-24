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
    var zipCode = "00000" // if this shows up in DB, there are problems.
    
    override func viewDidLoad() {
        let userID = rootRef.authData.uid
        // set zipcode
        if let object = userDefaults.objectForKey(userID)?.valueForKey(userID){
            self.zipCode = object.objectForKey("ZipCode")! as! String
            //print("mainZip is")
            //print(self.zipCode)
            
        }
        
        itemImageView.image = tempUI // this displays the image
        if (itemImageView.image != nil){
            base64Encode()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // nothing atm
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
            //print(snapshot.description)
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
        
        
        let itemID = String(zipRef.childByAutoId())
        let r = itemID.startIndex.advancedBy(62)
        let itemIDSubString = itemID.substringFromIndex(r)
        
        
        
        let zipInfo = ["Description": itemDescription, "Price" : itemPrice, "ItemZipCode" : itemZipCode, "OwnerID" : ownerID, "base64Encoding" : base64String, "BuyerID" : soldTo, "ItemID": String(itemIDSubString)]
        
        let userSellingInfo = zipInfo

        
        zipRef.setValue(zipInfo)
        userDB_ref.childByAppendingPath("Selling").setValue(userSellingInfo)
    }
    
   // https://aggle.firebaseio.com/ZipDB/11112/    40
    
    
    
    
    
    
    
    
    
    
}
