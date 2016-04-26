//
//  ItemDetail.swift
//  aggle
//
//  This controller (yes it should be renamed ItemDetailController), is for filling in 
//  information about an item that the user wants to sell
//
//  Created by Jose Lemus on 4/21/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ItemDetail: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    let user = User.sharedInstance
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView : UIImageView!
    @IBOutlet weak var itemDescription2: UITextView!
    
    let rootRef = Firebase(url:"https://aggle2.firebaseio.com/")
    var tempUI = UIImage()
    var base64String = String()
    var zipCode = "" // if this shows up in DB, there are problems.
    var TAG: String = "[ItemDetail]"
    
    
    override func viewDidLoad() {
        /* Set up top bar */
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        /* Set the background, and layout of the scene */
        itemDescription2.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        itemDescription2.layer.borderWidth = 1.0
        itemDescription2.layer.cornerRadius = 5
        
        self.zipCode = user.zip
        
        itemImageView.image = tempUI
        if (itemImageView.image != nil){
            base64Encode()
        }
 
    }
    

    
    //Only function in use for moving on text box click
    @IBAction func editingPriceBegan(sender: AnyObject) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        // if you want to slide up the view
        var rect: CGRect = self.view.frame
        rect.origin.y = -150
        
        self.view.frame = rect
        UIView.commitAnimations()
    }
    
    func textViewDidBeginEditing(itemDescription2: UITextView) {
        self.itemDescription2.text = ""
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        // if you want to slide up the view
        var rect: CGRect = self.view.frame
        rect.origin.y = -150
        
        self.view.frame = rect
        UIView.commitAnimations()
    }
    
    
    //Deprecated
    @IBAction func editingPriceEndedV2(sender: AnyObject) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        var rect: CGRect = self.view.frame
        rect.origin.y += 100
        
        self.view.frame = rect
        UIView.commitAnimations()
    }
    
    //Deprecated
    @IBAction func DescriptionEditingBegin(sender: AnyObject) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        // if you want to slide up the view
        var rect: CGRect = self.view.frame
        rect.origin.y -= 100
        
        self.view.frame = rect
        UIView.commitAnimations()
        
    }
    
    //Deprecated
    @IBAction func DescriptionEditingEnd(sender: AnyObject) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        var rect: CGRect = self.view.frame
        rect.origin.y += 100
        
        self.view.frame = rect
        UIView.commitAnimations()
        
    }

    func base64Encode(){
        let image : UIImage = itemImageView.image! as UIImage
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        self.base64String = String(imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))
    }
    
    
    //Submit Button action
    @IBAction func setItemDetails(sender: AnyObject) {

        //Need check for valid input
        print(self.TAG + itemPrice.text!)
        print(self.TAG + itemDescription2.text!)

        priceLabel.text = itemPrice.text
        self.user.priceArray.append(itemPrice.text!)
        self.user.descArray.append(itemDescription2.text)
        self.user.picArray.append(self.base64String)
        self.user.numberSold += 1
        updateDataBase(itemDescription2.text!, price: itemPrice.text!)
    }
    
    
    func updateDataBase(description:String, price: String){
        let userDB_ref = rootRef.childByAppendingPath("UsersDB/" + rootRef.authData.uid)
        
        userDB_ref.observeSingleEventOfType(.Value, withBlock: {snapshot in
            //print(snapshot.description)
            self.zipCode = snapshot.value.objectForKey("ZipCode") as! String
            print(self.TAG + self.zipCode)
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
    
    @IBAction func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        var rect: CGRect = self.view.frame
        rect.origin.y = 0
        
        self.view.frame = rect
        UIView.commitAnimations()
    }
}
