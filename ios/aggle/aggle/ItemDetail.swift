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
    
    
    override func viewDidLoad() {
        itemImageView.image = tempUI // this displays the image
    }
    
    override func viewWillAppear(animated: Bool) {
        print("hi hi")
    }
    
    
    
    @IBAction func setItemDetails(sender: AnyObject) {
        
        descriptionLabel.text = itemDescription.text
        print("Final Price is ")
        priceLabel.text = itemPrice.text
    }
    
    
    
    
}
