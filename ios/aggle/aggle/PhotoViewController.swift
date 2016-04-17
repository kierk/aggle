//
//  PhotoViewController.swift
//  aggle
//
//  Created by Max Li on 3/22/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var currentImage: UIImageView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    internal var base64Image = "";
    
     let ref = Firebase(url:"https://aggle.firebaseio.com/")
     
    
    // this is button
    @IBAction func takePicture(sender: UIButton) {
        
        
        
        
        
        
        
        //===========================================================================================
        //============================== code below is for camera stuff //============================
        //============================================================================================

//            if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
//            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
//                imagePicker.allowsEditing = false
//                imagePicker.sourceType = .Camera
//                imagePicker.cameraCaptureMode = .Photo
//                presentViewController(imagePicker, animated: true, completion: {})
//                
//                
//                
//                
//            } else {
//                print(("Rear camera doesn't exist", message: "Application cannot access the camera."))
//            }
//        } else {
//            print(("Camera inaccessable", message: "Application cannot access the camera."))
//        }
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(PhotoViewController.setBttnTouched(_:)))
        
        //===========================================================================================
        //============================== code below is for camera stuff //============================
        //============================================================================================
        
//        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//            print("Got an image")
//            if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
//                //let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
//                //UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
//            }
//            imagePicker.dismissViewControllerAnimated(true, completion: {
//                print("hey")
//                func UIImageWriteToSavedPhotosAlbum(pickedImage: UIImage){
//                    print("heyyyyyy")
//                }
//            })
//        }
//        
//        func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//            print("User canceled image")
//            dismissViewControllerAnimated(true, completion: {
//                // Anything you want to happen when the user selects cancel
//            })
//        }
//        
//        
//        
//
//        // Do any additional setup after loading the view.
//        //super.viewDidLoad()
    
    //====================================================================================================//
    //===================================================================================================//
    
    }
    
    
    
    
    func setBttnTouched(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("photoSettingsSegue", sender: self)
        
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        ImageDisplay.image=info[UIImagePickerControllerOriginalImage]as?UIImage;dismissViewControllerAnimated(true, completion: nil)
        
        print("[imagePickerController] hi");
        
        
        
        
        // this stores the UIImage object in var image.
        let image : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        let imageData = UIImagePNGRepresentation(image);
        
        
        // this encodes correctly
         self.base64Image = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength);
        
        //print("\n\n\nthis is the original data\n\n\n" + String(imageData))
        
        print("\nthis is the encoded data\n\n\n\n " + self.base64Image)
        
        
        //this is for decoding for later
        let decodedData = NSData(base64EncodedString: self.base64Image, options:NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        //print("\n\n\n\n\n\n\n\nthis is the decoded data" + String(decodedData))
        
        
        
        
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
