//
//  MessageViewController.swift
//  aggle
//
//  Created by Max Li on 4/10/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import Firebase
class MessageViewController: UIViewController {

    
    @IBOutlet weak var showImage: UIImageView!
    
    
    //@IBOutlet var showImage: UIImageView!
    //let imageRef = Firebase(url: "https://aggle.firebaseio.com/items_for_sale")
    
    
    
    
    
    
    
    override func viewDidLoad() {
        print("[viewDidLoad] hi")
        super.viewDidLoad()
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(MessageViewController.setBttnTouched(_:)))

//        
//        let imageRef = Firebase(url: "https://aggle.firebaseio.com/items_for_sale")
//        
//        
////        var myimage = UIImage(named : "crock_20")
////        showImage.image = myimage
////        view.addSubview(self.showImage)
//        
//        
//        
//        
//        imageRef.observeEventType(.ChildAdded, withBlock: {snapshot in
//            print("heyyyy ChildAdded")
//            
//            
//            var imageEncodedData = String(snapshot.value.objectForKey("pic_base64")!)
//            
//            
//            //let url = NSURL(URLWithString)
//            //print(imageEncodedData)
//            
//            let decodedData = NSData(base64EncodedString: imageEncodedData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
//            //print(decodedData)
//            
//  
//            
//            
//            if decodedData != nil{
//                print("in decoding data")
//                let image = UIImage(data: decodedData!)
//                
//                self.showImage.image = image as UIImage!
//            }
//        })
    }
    
    
    
    func setBttnTouched(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("convoSettingsSegue", sender: self)
        
    }
    
}


        //self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    
    


//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


    
    
    
    
    
    
    
    


