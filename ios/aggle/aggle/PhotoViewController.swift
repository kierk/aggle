//
//  PhotoViewController.swift
//  aggle
//
//  This is the SELL/CAMERA screen
//  This controller is used to display the sell camera
//
//  Created by Max Li on 3/22/1s6.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var currentImage: UIImageView!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    internal var base64Image = "";
    let ref = Firebase(url:"https://aggle2.firebaseio.com/")
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var capturedImage: UIImageView!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    var TAG: String = "[PhotoViewController]"
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        print(TAG + "viewDidLoad")
        super.viewDidLoad()
        imagePicker.delegate = self
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(PhotoViewController.setBttnTouched(_:)))
        
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let myAlertView = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
            }
            myAlertView.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                // ...
            }
            myAlertView.addAction(OKAction)
            
            self.presentViewController(myAlertView, animated: true) {
                // ...
            } 
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        print(TAG + "viewWillAppear")
        super.viewWillAppear(animated)
        //captureSession = AVCaptureSession()
        //captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        //let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        //var error: NSError?
        //var input: AVCaptureDeviceInput!
        //do {
        //    input = try AVCaptureDeviceInput(device: backCamera)
        //} catch let error1 as NSError {
        //    error = error1
        //    input = nil
        //}
        //
        //if error == nil && captureSession!.canAddInput(input) {
        //    captureSession!.addInput(input)
        //
        //    stillImageOutput = AVCaptureStillImageOutput()
        //    stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        //    if captureSession!.canAddOutput(stillImageOutput) {
        //        captureSession!.addOutput(stillImageOutput)
        //
        //        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
        //        previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
        //        previewView.layer.addSublayer(previewLayer!)
        //        captureSession!.startRunning()
        //    }
        //}
    }
    
    @IBAction func selectPhoto(sender: UIButton) {
        print(TAG + "selectPhoto")
        var picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        self.presentViewController(picker, animated: true, completion: { _ in })
    }
    
    
    
    @IBAction func didPressTakePhoto(sender: UIButton) {
        print(TAG + "didPressTakePhoto")
        
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .Camera
        self.presentViewController(picker, animated: true, completion: { _ in })
    }

    
    
    @IBAction func didPressTakeAnother(sender: AnyObject) {
        captureSession!.startRunning()
    }
    
    
    func setBttnTouched(sender: UIBarButtonItem) {
        performSegueWithIdentifier("photoSettingsSegue", sender: self)
    }
    

    @IBAction func takePicture(sender: UIButton) {
        print(TAG + "takePicture")
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .Camera
        self.presentViewController(picker, animated: true, completion: { _ in })
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //===========================================================================================
    //============= code below is for base64 encoding of picture when pushed to db
    //============================================================================================
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Post: UIButton!
    @IBOutlet weak var ImageDisplay: UIImageView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(TAG + "prepareForSegue")
        
        if(segue.identifier == "segueItemDetails"){
            
            let DestViewController = segue.destinationViewController as! ItemDetail
            
            DestViewController.tempUI = self.image!
           
        }
    }
    
    // this function is triggered when user presses post on the app.
    @IBAction func PostAction(sender: UIButton) {
        print(TAG + "[PostAction]")
            }
    
    @IBAction func PhotoLibraryAction(sender: UIButton) {
        print(TAG + "[PhotoLibraryAction] hi");
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    /* this function is trigered when a picture is selected from the photo library.
     * The function encodes the selected picture to base64 and sets the global variable
     * base64image to hold the encoded data of the image that is selected 
     **/
    func imagePickerController(picker:UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(TAG + "imagePickerController")
        
        //info is a dictionary that has lots of metadata on the image that you pick
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.image = chosenImage
        capturedImage.contentMode = .ScaleAspectFit
        capturedImage.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
        
        performSegueWithIdentifier("segueItemDetails", sender: self)
        
        //let chosenImage: UIImage = ([UIImagePickerControllerOriginalImage]as?UIImage)!;dismissViewControllerAnimated(true, completion: nil)
        //self.capturedImage.image = chosenImage
        //picker.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: { _ in })
    }

    @IBAction func cancelToPlayersViewController(segue:UIStoryboardSegue) {
        //
    }
}
