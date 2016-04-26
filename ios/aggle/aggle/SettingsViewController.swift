//
//  SettingsViewController.swift
//  aggle
//
//  This is the Settings Screen.
//
//  Created by Max Li on 4/17/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var zipCode: UITextField!
    let user = User.sharedInstance
    var TAG: String = "[SettingsViewController]"
    
    let ref = Firebase(url:"https://aggle2.firebaseio.com/")
    
    @IBAction func edit(sender: AnyObject) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Enter new zip code", message: "", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.zipCode.text = textField.text
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    @IBAction func save(sender: AnyObject) {
        
        let userInfo = ["Full Name" : self.user.name, "Email": self.user.email, "ZipCode": zipCode.text]
        
        let usersRef = self.ref.childByAppendingPath("UsersDB")
        
        User.sharedInstance.zip = zipCode.text
        
        let users = [self.user.uid : userInfo]
        usersRef.updateChildValues(users)
        
    }
    
    
    func load_image(urlString:String) {
        print(TAG + "load_image")
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil) {
                func display_image() {
                    self.pic.image = UIImage(data: data!)
                }
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
        }
        
        task.resume()
    }
    
    override func viewDidLoad() {
        print(TAG + "viewDidLoad")
        super.viewDidLoad()
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.pic.layer.cornerRadius = pic.frame.size.height / 2
        self.pic.layer.masksToBounds = true;
        
        
        load_image(self.user.pic)
        name.text = self.user.name
        zipCode.text = self.user.zip
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(SettingsViewController.setBttnTouched(_:)))
        
        
        
    }
    
    
    func setBttnTouched(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("ViewControllerSegue", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    //}
}
