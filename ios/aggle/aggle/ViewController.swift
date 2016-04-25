//
//  ViewController.swift
//  aggle
//
//  This is the Login screen (the one w/ Facebook and all that fun stuff). 
//  It should be renamed into something like LgoinViewController.
//
//  Created by Max Li on 3/3/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

let userDefaults = NSUserDefaults.standardUserDefaults()

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    let TAG = "[ViewController]"
    let user = User.sharedInstance
    let ref = Firebase(url:"https://aggle.firebaseio.com/")
    var mainZipCode : String = ""
    
    @IBOutlet weak var zipText: UITextField!
    
    @IBAction func enterZip(sender: AnyObject) {
        if (Int(zipText.text!) != nil && zipText.text!.characters.count == 5){
            self.mainZipCode = zipText.text!
            zipText.text = ""
        }
        else {
            let alert = UIAlertController(title: "Warning", message: "Enter a valid zip code please", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
            }
            alert.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Okay", style: .Default) { (action) in
                // ...
            }
            alert.addAction(OKAction)
            
            self.presentViewController(alert, animated: true) {
                // ...
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Make the top bar */
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        print(TAG + "viewDidLoad");
        FBSDKAccessToken.setCurrentAccessToken(nil)  // for debugging when a new user logs in
        FBSDKProfile.setCurrentProfile(nil)
        
        if (FBSDKAccessToken.currentAccessToken() != nil){  // if user has token, go to main screen
            print(TAG + "AccessToken exists");
            print(TAG + FBSDKAccessToken.currentAccessToken().userID)
            self.performSegueWithIdentifier("showNew", sender: self)
        } else {   //if user doesn't have token, go here
            FBSDKAccessToken.setCurrentAccessToken(nil)  // for debugging when a new user logs in
            FBSDKProfile.setCurrentProfile(nil)
        
            print(TAG + "AccessToken doesn't exist exists")
            
            /* Make a button that asks the user for some Facebook permissions */
            let loginButton = FBSDKLoginButton()
            loginButton.readPermissions = ["public_profile", "email", "user_friends"] // eugenek: Why are we getting user_friends? lol
            loginButton.center = self.view.center
            loginButton.delegate = self
            
            self.view.addSubview(loginButton)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print(TAG + "loginButton clicked");
        
        if error != nil {
            print(TAG + error.localizedDescription)
        } else if result.isCancelled {
            //
        } else {
            print(TAG + "logging the user in");
            
            let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            
            ref.authWithOAuthProvider("facebook", token: accessToken,
                withCompletionBlock: { error, authData in
                    
                    self.performSegueWithIdentifier("showNew", sender: self) //here new change
                    
                    /* (Re)Create a user model with previous data from the database */
                    self.user.name = String((authData.providerData["displayName"])!)
                    if (self.mainZipCode == ""){
                        self.mainZipCode = "02215"
                    }
                    self.user.zip = self.mainZipCode
                    self.user.email = String((authData.providerData["email"])!)
                    self.user.pic = String((authData.providerData["profileImageURL"])!)
                    self.user.uid = authData.uid
                    
                    // initialize the dicitonary to be stored in userDefaults
                    let userDict : [String : [String:String]] = [
                        self.user.uid : ["ZipCode" : self.user.zip, "Full Name" : self.user.name]
                    ]
                    
                    // ------------ BEGIN ------------
                    // eugenek: Should this not be removed?
                    // set the userDefault
                    userDefaults.setObject(userDict, forKey: self.user.uid)
                    
                    // first get values for userID, then get values for zipCode
                    if let object = userDefaults.objectForKey(self.user.uid)?.valueForKey(self.user.uid){
                        self.mainZipCode = object.objectForKey("ZipCode")! as! String
                        
                    }
                    // ------------ END ---------------

                    let userInfo = ["Full Name" : self.user.name, "Email": self.user.email, "ZipCode": self.user.zip,]
                    let usersRef = self.ref.childByAppendingPath("UsersDB")
                    let user = [authData.uid : userInfo]
                    usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        if snapshot.hasChild(self.user.uid) {
                            // let my man go
                        } else {
                            usersRef.updateChildValues(user)
                        }
                    })
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print(TAG + "in logout");
    }
}

