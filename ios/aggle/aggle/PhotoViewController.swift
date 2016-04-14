//
//  PhotoViewController.swift
//  aggle
//
//  Created by Max Li on 3/22/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import Firebase

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal var base64Image = "";
    
     let ref = Firebase(url:"https://aggle.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        // Do any additional setup after loading the view.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Post: UIButton!
    
    @IBAction func PostAction(sender: UIButton) {
        
        print("[PostAction] hey");
        
        let picBase64 = self.base64Image;
        let description = "test description of item"
        let price = 11235
        let imageInfo = ["description" : description, "price" : price, "pic_base64" : picBase64, "owner_id" : "authData.uid"] // value for image uploaded
        
        let imageRef = ref.childByAppendingPath("items_for_sale");
        let imageIDref = imageRef.childByAutoId()  // this generates a unique ID each time it is called. When can then use this to find the image later on. Note that this is now the ref that we will update
        
        imageIDref.updateChildValues(imageInfo as [NSObject : AnyObject]) // this updates the DB
    }
    
    
    
    @IBAction func PhotoLibraryAction(sender: UIButton) {
        
        print("[PhotoLibraryAction] hi");
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)

    }
    
    @IBOutlet weak var ImageDisplay: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        ImageDisplay.image=info[UIImagePickerControllerOriginalImage]as?UIImage;dismissViewControllerAnimated(true, completion: nil)
        
        print("[imagePickerController] hi");
        
        
        
        
        // this stores the UIImage object in temp.
        let image : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        let imageData = UIImagePNGRepresentation(image);
        
        
        // this encodes correctly
         self.base64Image = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength);
        
        // this is for decoding for later
        //let decodedData = NSData(self.base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        
        
        // for debugging breakpoints
        
        
        
        
        _ = 5;
        

        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
