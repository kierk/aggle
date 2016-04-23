//
//  ViewController.swift
//  aggle
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
    
    let user = User.sharedInstance
    //let zip =
    
    
    
    @IBOutlet weak var zipText: UITextField!
    let ref = Firebase(url:"https://aggle.firebaseio.com/")
    var mainZipCode : String = ""
    
    @IBAction func enterZip(sender: AnyObject) {
        if (Int(zipText.text!) != nil && zipText.text!.characters.count == 5){
            self.mainZipCode = zipText.text!
            zipText.text = ""
        }
        else{
            let alert = UIAlertView()
            alert.message = "Enter a valid zip code please"
            alert.addButtonWithTitle("Okay")
            alert.show()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        print("[\nViewController/viewDidLoad] hi");
        //FBSDKAccessToken.setCurrentAccessToken(nil)  // for debugging when a new user logs in
        //FBSDKProfile.setCurrentProfile(nil)
        
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil){  // if user has token, go to main screen
            print("AccessToken exists");
            print(FBSDKAccessToken.currentAccessToken().userID)
            
            self.performSegueWithIdentifier("showNew", sender: self)
            
        }
            
            
        
        
        else{   //if user doesn't have token, go here
            
            
            //FBSDKAccessToken.setCurrentAccessToken(nil)  // for debugging when a new user logs in
            //FBSDKProfile.setCurrentProfile(nil)
            

            print("AccessToken doesn't exist exists")
            
            
            //print(FBSDKAccessToken.currentAccessToken().userID)
            
            let loginButton = FBSDKLoginButton()
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.center = self.view.center
            loginButton.delegate = self
            
            self.view.addSubview(loginButton)
            print("here, loaded correctly")
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -- Facebook Login
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        print("[\nViewController/loginButton] hi");
        
        
        if error != nil {  // This means we have an error
            print(error.localizedDescription)
            
        }
        
        else if result.isCancelled {
            
        }
            
            
        
        else {
            
            print("[\nViewController/loginButton] in login else");
            
            
            
            let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            
            ref.authWithOAuthProvider("facebook", token: accessToken,
                withCompletionBlock: { error, authData in
                    
                    
                    self.performSegueWithIdentifier("showNew", sender: self) //here new change
                    
                    
                    self.user.name = String((authData.providerData["displayName"])!)
                    
                    print(authData)
                    print("Logged in! \(authData) The Users uid is \(authData.uid)")
                    print("And their display name is \(authData.providerData["displayName"])")
                    print("And their email is \(authData.providerData["email"])")
                    //_ = String(authData.uid)
                        
                    let userDisplayName = String((authData.providerData["displayName"])!)   // probably btter way of doing this
                        
                    let userEmail = String((authData.providerData["email"])!)
                    
                    if (self.mainZipCode == ""){
                        self.mainZipCode = "02215"
                    }
                    
                    self.user.zip = self.mainZipCode
                    self.user.email = userEmail
                    self.user.pic = String((authData.providerData["profileImageURL"])!)
                    
                    
                    
                    var varConstants = [String]()
                    
                    varConstants.append(authData.uid)
                    varConstants.append(self.mainZipCode)
                    varConstants.append(userDisplayName)
                    
                    //userDefaults.setObject(self.mainZipCode, forKey: authData.uid)
                    userDefaults.setObject(varConstants, forKey: authData.uid)
                    
                    
                    
                    
                    
                    print("in viewcontroller id is " + authData.uid)
                    print("in viewcontroller zipcode is " + self.mainZipCode)
                    print("in viewcontroller displayname is " + userDisplayName)
                    
                    let userInfo = ["Full Name" : userDisplayName, "Email": userEmail, "ZipCode": self.mainZipCode,
                        ] // key is uid
                    
                        
                    let usersRef = self.ref.childByAppendingPath("UsersDB")
                    print("zipcode is " + self.mainZipCode)
                    
                    User.sharedInstance.zip = self.mainZipCode
                    
                    print(User.sharedInstance.zip)
                    
                    let users = [authData.uid : userInfo]
                    usersRef.updateChildValues(users)
                    
                    
                    
            })
            
        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("in logout");
        
    }

    
    
}

