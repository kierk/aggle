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


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    let TAG = "[ViewController]"
    let user = User.sharedInstance
    
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
        
        print(TAG + "[viewDidLoad] hi");
        //FBSDKAccessToken.setCurrentAccessToken(nil)  // for debugging when a new user logs in
        //FBSDKProfile.setCurrentProfile(nil)
        
        if (FBSDKAccessToken.currentAccessToken() != nil){  // if user has token, go to main screen
            print(TAG + "AccessToken exists");
            print(TAG + FBSDKAccessToken.currentAccessToken().userID)
            self.performSegueWithIdentifier("showNew", sender: self)
        } else {   //if user doesn't have token, go here
            //FBSDKAccessToken.setCurrentAccessToken(nil)  // for debugging when a new user logs in
            //FBSDKProfile.setCurrentProfile(nil)
        
            print(TAG + "AccessToken doesn't exist exists")
            
            //print(FBSDKAccessToken.currentAccessToken().userID)
            
            let loginButton = FBSDKLoginButton()
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.center = self.view.center
            loginButton.delegate = self
            
            self.view.addSubview(loginButton)
            print(TAG + "here, loaded correctly")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        print(TAG + "[ViewController/loginButton] hi");
        
        if error != nil {  // This means we have an error
            print(TAG + error.localizedDescription)
        } else if result.isCancelled {
            //
        } else {
            print("TAG + [ViewController/loginButton] in login else");
            
            let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            
            ref.authWithOAuthProvider("facebook", token: accessToken,
                withCompletionBlock: { error, authData in
                    
                    self.performSegueWithIdentifier("showNew", sender: self) //here new change
                    
                    self.user.name = String((authData.providerData["displayName"])!)
                    
                    print(authData)
                    print(self.TAG + "Logged in! \(authData) The Users uid is \(authData.uid)")
                    print(self.TAG + "And their display name is \(authData.providerData["displayName"])")
                    print(self.TAG + "And their email is \(authData.providerData["email"])")
                    
                    let userDisplayName = String((authData.providerData["displayName"])!)   // probably btter way of doing this
                    let userEmail = String((authData.providerData["email"])!)
                    
                    if (self.mainZipCode == ""){
                        self.mainZipCode = "02215"
                    }
                    
                    self.user.zip = self.mainZipCode
                    self.user.email = userEmail
                    self.user.pic = String((authData.providerData["profileImageURL"])!)
                    
                    
                    let userInfo = ["Full Name" : userDisplayName, "Email": userEmail, "ZipCode": self.mainZipCode,] // key is uid
                    
                    let usersRef = self.ref.childByAppendingPath("UsersDB")
                    print(self.TAG + "zipcode is " + self.mainZipCode)
                    
                    User.sharedInstance.zip = self.mainZipCode
                    
                    print(self.TAG + User.sharedInstance.zip)
                    
                    let users = [authData.uid : userInfo]
                    usersRef.updateChildValues(users)
            })
        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print(TAG + "in logout");
    }
}

