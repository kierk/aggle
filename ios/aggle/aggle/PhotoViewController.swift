//
//  PhotoViewController.swift
//  aggle
//
//  Created by Max Li on 3/22/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import AssetsLibrary
import Firebase

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
//    var uploadRequests = Array<AWSS3TransferManagerUploadRequest?>()  // h ttps://github.com/awslabs/aws-sdk-ios-samples/blob/master/S3TransferManager-Sample/Swift/S3TransferManagerSampleSwift/UploadViewController.swift
//    var uploadFileURLs = Array<NSURL?>()
    
    
    
    
    let ref = Firebase(url:"https://aggle.firebaseio.com/imageURL")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        // Do any additional setup after loading the view.
        
        
        
        //  h ttps://github.com/awslabs/aws-sdk-ios-samples/blob/master/S3TransferManager-Sample/Swift/S3TransferManagerSampleSwift/  UploadViewController.swift
//        let error = NSErrorPointer()
//        do {
//            try NSFileManager.defaultManager().createDirectoryAtURL(
//                NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("upload"),
//                withIntermediateDirectories: true,
//                attributes: nil)
//        } catch let error1 as NSError {
//            error.memory = error1
//            print("Creating 'upload' directory failed. Error: \(error)")
//        }
        
        
        // end h ttps://github.com/awslabs/aws-sdk-ios-samples/blob/master/S3TransferManager-Sample/Swift/S3TransferManagerSampleSwift/UploadViewController.swift
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Post: UIButton!
    
    
    @IBAction func handleDBPUSH(sender: UIButton) {
        
        let uploadImage = UIImage(named: "image.png")
        //var imageData : NSData = UIImagePNGRepresentation(uploadImage)
        //self.base64String = imageData
        
        
    }
    
    
    
    
    @IBAction func PostAction(sender: UIButton) {
    }
    
    @IBAction func PhotoLibraryAction(sender: UIButton) {  // this function brings up gallery on phone
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)

    }
    
    @IBOutlet weak var ImageDisplay: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {   // triggered when you choose a picture
        
       
        
        ImageDisplay.image=info[UIImagePickerControllerOriginalImage]as?UIImage;dismissViewControllerAnimated(true, completion: nil)
        
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


//UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate

class UploadViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,ELCImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var uploadRequests = Array<AWSS3TransferManagerUploadRequest?>()
    var uploadFileURLs = Array<NSURL?>()
    var endURLPATH = ""
    
    
    let ref = Firebase(url:"https://aggle.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let error = NSErrorPointer()
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(
                NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("upload"),
                withIntermediateDirectories: true,
                attributes: nil)
        } catch let error1 as NSError {
            error.memory = error1
            print("Creating 'upload' directory failed. Error: \(error)")
        }
    }
    
    @IBAction func showAlertController(barButtonItem: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: "Available Actions",
            message: "Choose your action.",
            preferredStyle: .ActionSheet)
        
        let selectPictureAction = UIAlertAction(
            title: "Select Pictures",
            style: .Default) { (action) -> Void in
                self.selectPictures()
        }
        alertController.addAction(selectPictureAction)
        
        let cancelAllUploadsAction = UIAlertAction(
            title: "Cancel All Uploads",
            style: .Default) { (action) -> Void in
                self.cancelAllUploads()
        }
        alertController.addAction(cancelAllUploadsAction)
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .Cancel) { (action) -> Void in }
        alertController.addAction(cancelAction)
        
        self.presentViewController(
            alertController,
            animated: true) { () -> Void in }
    }
    
    func selectPictures() {
        let imagePickerController = ELCImagePickerController()
        imagePickerController.maximumImagesCount = 20
        imagePickerController.imagePickerDelegate = self
        
        self.presentViewController(
            imagePickerController,
            animated: true) { () -> Void in }
    }
    
    func upload(uploadRequest: AWSS3TransferManagerUploadRequest) {
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                if error.domain == AWSS3TransferManagerErrorDomain as String {
                    if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch (errorCode) {
                        case .Cancelled, .Paused:
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.collectionView.reloadData()
                            })
                            break;
                            
                        default:
                            print("upload() failed: [\(error)]")
                            break;
                        }
                    } else {
                        print("upload() failed: [\(error)]")
                    }
                } else {
                    print("upload() failed: [\(error)]")
                }
            }
            
            if let exception = task.exception {
                print("upload() failed: [\(exception)]")
            }
            
            if task.result != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let index = self.indexOfUploadRequest(self.uploadRequests, uploadRequest: uploadRequest) {
                        self.uploadRequests[index] = nil
                        self.uploadFileURLs[index] = uploadRequest.body
                        print(self.uploadFileURLs[0])
                        
                        
                        var myURL = self.uploadFileURLs[0]?.absoluteString
                        var urlRef = self.ref.childByAppendingPath("users") // url as string
                        
                        //var users = [authData.uid : userInfo]
                       // urlRef.updateChildValues(users)
                        
                        
                        let indexPath = NSIndexPath(forRow: index, inSection: 0)
                        self.collectionView.reloadItemsAtIndexPaths([indexPath])
                    }
                })
            }
            return nil
        }
    }
    
    func cancelAllUploads() {
        for (_, uploadRequest) in self.uploadRequests.enumerate() {
            if let uploadRequest = uploadRequest {
                uploadRequest.cancel().continueWithBlock({ (task) -> AnyObject! in
                    if let error = task.error {
                        print("cancel() failed: [\(error)]")
                    }
                    if let exception = task.exception {
                        print("cancel() failed: [\(exception)]")
                    }
                    return nil
                })
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.uploadRequests.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "UploadCollectionViewCell",
            forIndexPath: indexPath) as! UploadCollectionViewCell
        
        if let uploadRequest = self.uploadRequests[indexPath.row] {
            switch uploadRequest.state {
            case .Running:
                if let data = NSData(contentsOfURL: uploadRequest.body) {
                    cell.imageView.image = UIImage(data: data)
                    cell.label.hidden = true
                }
                
                uploadRequest.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if totalBytesExpectedToSend > 0 {
                            cell.progressView.progress = Float(Double(totalBytesSent) / Double(totalBytesExpectedToSend))
                        }
                    })
                }
                
                break;
                
            case .Canceling:
                cell.imageView.image = nil
                cell.label.hidden = false
                cell.label.text = "Cancelled"
                break;
                
            case .Paused:
                cell.imageView.image = nil
                cell.label.hidden = false
                cell.label.text = "Paused"
                break;
                
            default:
                cell.imageView.image = nil
                cell.label.hidden = true
                break;
            }
        }
        
        if let downloadFileURL = self.uploadFileURLs[indexPath.row] {
            if let data = NSData(contentsOfURL: downloadFileURL) {
                cell.imageView.image = UIImage(data: data)
                cell.label.hidden = false
                cell.label.text = "Uploaded"
                cell.progressView.progress = 1.0
                print(downloadFileURL)
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        if let uploadRequest = self.uploadRequests[indexPath.row] {
            switch uploadRequest.state {
            case .Running:
                uploadRequest.pause().continueWithBlock({ (task) -> AnyObject! in
                    if let error = task.error {
                        print("pause() failed: [\(error)]")
                    }
                    if let exception = task.exception {
                        print("pause() failed: [\(exception)]")
                    }
                    
                    return nil
                })
                break
                
            case .Paused:
                self.upload(uploadRequest)
                collectionView.reloadItemsAtIndexPaths([indexPath])
                break
                
            default:
                break
            }
        }
    }
    
    func elcImagePickerController(picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        for (_, imageDictionary) in info.enumerate() {
            if let imageDictionary = imageDictionary as? Dictionary<String, AnyObject> {
                if let mediaType = imageDictionary[UIImagePickerControllerMediaType] as? String {
                    if mediaType == ALAssetTypePhoto {
                        if let image = imageDictionary[UIImagePickerControllerOriginalImage] as? UIImage {
                            let fileName = NSProcessInfo.processInfo().globallyUniqueString.stringByAppendingString(".png")
                            let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("upload").URLByAppendingPathComponent(fileName)
                            let filePath = fileURL.path!
                            let imageData = UIImagePNGRepresentation(image)
                            imageData!.writeToFile(filePath, atomically: true)
                            
                            let uploadRequest = AWSS3TransferManagerUploadRequest()
                            uploadRequest.body = fileURL
                            uploadRequest.key = fileName
                            uploadRequest.bucket = S3BucketName
                            
                            self.uploadRequests.append(uploadRequest)
                            self.uploadFileURLs.append(nil)
                            
                            self.upload(uploadRequest)
                        }
                    }
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    func elcImagePickerControllerDidCancel(picker: ELCImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func indexOfUploadRequest(array: Array<AWSS3TransferManagerUploadRequest?>, uploadRequest: AWSS3TransferManagerUploadRequest?) -> Int? {
        for (index, object) in array.enumerate() {
            if object == uploadRequest {
                return index
            }
        }
        return nil
    }
}

class UploadCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
}