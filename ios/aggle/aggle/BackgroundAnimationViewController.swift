//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  This is the main screen right now w/ all the swiping.
//
//  Created by Eugene Andreyev on 7/11/15.
//  Modified heavilty by Jose Lemus on 4/25/2016
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop
import Firebase

private let numberOfCards: UInt = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1
var actuallySwiped = false



var mainDecodedDataList = [NSData]()
var mainItemIDList = [String]()

var mainDecodedUserDefault = NSUserDefaults.standardUserDefaults()

class BackgroundAnimationViewController: UIViewController{
    
    let swipeResult = KolodaView().swipe
    
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    
    
    
    
    
    var calledOnce = false
    var startAtRef = ""
    let rootRef = Firebase(url:"https://aggle2.firebaseio.com/")
    var zipCode : String = "00000"
    var size : Int = 0 // size for decoded data list
    var displayNmae : String = ""
    var itemIDListSize : Int = 0 // size for itemIDlist
    var firstDBPull = false
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("STARTING\n")
        
        
        let userID = rootRef.authData.uid
        //super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        
        
        
        if let object = userDefaults.objectForKey(userID)?.valueForKey(userID){
            self.zipCode = object.objectForKey("ZipCode")! as! String
            self.displayNmae = object.objectForKey("Full Name") as! String
            print(self.displayNmae)
            print(rootRef.authData.uid)
            
        }
        
        
        pullValuesFromDB(self.zipCode)
        
    }
    
    
    @IBAction func leftButtonSelectorV2(sender: AnyObject?) {
        print("in left button")
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    
    @IBAction func rightButtonTapped() {
        print("\n[inRightButtonAction]\n")
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection){
        
        print("the index is : \(index)")
        
        
        
        
        if(mainItemIDList.count == 1){
            pullValuesFromDB(self.zipCode)
        }
        
        if(direction == SwipeResultDirection.Right){
            
            let userLikes_ref = rootRef.childByAppendingPath("UsersDB/\(rootRef.authData.uid)/Likes")
            //let convoRef = self.rootRef.childByAppendingPath("ConvoDB/" + convoId + "/item")
            
            if itemIDListSize > 0{                          // check if itemIDList is not empty
                let likedItemID = mainItemIDList.popLast() // assigns the last element of mainItemIDList to
                
                
                var likedInfoDic = [:]
                likedInfoDic = [likedItemID! : likedItemID!]
                
                userLikes_ref.updateChildValues(likedInfoDic as [NSObject : AnyObject])
                
               // let convoRef = rootRef.childByAppendingPath("ConvoDB/").childByAutoId().childByAppendingPath(likedItemID)
                
                
                
                
            }
        }
            
        else{
            let userLikes_ref = rootRef.childByAppendingPath("UsersDB/\(rootRef.authData.uid)/DisLikes")
            if(itemIDListSize > 0){  // check if itemIDList is not empty
                
                let likedItemID = mainItemIDList.popLast() // assigns the last element of mainItemIDList to
                var likedInfoDic = [:]
                likedInfoDic = [likedItemID! : likedItemID!]
                userLikes_ref.updateChildValues(likedInfoDic as [NSObject : AnyObject])
                
            }
        }
        
        
    }
    
    
    @IBAction func undoButtonTapped() {
        //print("[@IBAction func undoButtonTapped()]")
        kolodaView?.revertAction()
    }
    
    
    func checkIfListSizeIsZero() -> Void{
        if mainDecodedDataList.count == 0{
            pullValuesFromDB(self.zipCode)
        }
        self.calledOnce = false
    }
    
    
    func pullValuesFromDB(zipCode : String){
        let currentUserZipCodeRef = rootRef.childByAppendingPath("ZipDB/" + self.zipCode)
       
        currentUserZipCodeRef.queryLimitedToLast(5).observeSingleEventOfType(.Value, withBlock: {zipKeys in
            
            for zipKeys in zipKeys.children{
                
                let tempOwner = (zipKeys).value.objectForKey("OwnerID") as! String
                
                if let base64EncodedString = (zipKeys).value.objectForKey("base64Encoding"){
                    print("hey base64 pass")
                    if let myItemID = (zipKeys).value.objectForKey("ItemID"){
                        print("hey myItemIDpass pass \(myItemID)")
                        if((((zipKeys).value.objectForKey("OwnerID")) as! String) != self.rootRef.authData.uid){
                            print(tempOwner)  // should not be user that is logged in
                            
                            
                            
                            self.base64decode(base64EncodedString as! String, itemID: myItemID as! String)
                            if(self.firstDBPull == false){
                                self.firstDBPull = true
                                self.kolodaView?.swipe(SwipeResultDirection.Right)
                            }
                            
                        }
                        
                    }
                }
            }
        })
    }
    

    func base64decode(encodedString : String, itemID : String){
        var decodedDataList = [NSData]()
        
        
        if let decodedData = NSData(base64EncodedString: encodedString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters){
            decodedDataList.append(decodedData)
            mainDecodedDataList.append(decodedData)
            mainItemIDList.append(itemID)
            
            
            
        }
        
        self.size = decodedDataList.count
        self.calledOnce = true
        self.itemIDListSize = mainItemIDList.count
        mainDecodedUserDefault.setInteger(self.itemIDListSize, forKey: rootRef.authData.uid)
        
        
    }
    
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        print("[kolodaDidRunOutOfCards]")
        kolodaView.resetCurrentCardIndex()
        kolodaView?.swipe(SwipeResultDirection.Left)
        
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        //Action on card tap
        //UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
        print("[koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt)]")
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        print("[kolodaShouldApplyAppearAnimation(koloda: KolodaView)]")
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        //print("[kolodaShouldMoveBackgroundCard(koloda: KolodaView)]")
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        //print("[kolodaShouldTransparentizeNextCard(koloda: KolodaView)]")
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        print("[koloda(kolodaBackgroundCardAnimation koloda: KolodaView)]")
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        
        return animation
    }
}




//MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    
    
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        print("[kolodaNumberOfCards(koloda: KolodaView)]")
        return numberOfCards
        
    }
    
    
    
    
    
    // this  function has to do with moving to new cards
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        
        if((mainDecodedDataList.count > 0)){
            // pass decoded array count to button
            //leftButtonSelectorV2(mainDecodedDataList[mainDecodedDataList.count - 1])
            return UIImageView(image: UIImage(data: mainDecodedDataList.popLast()!))
            
        }
            
        else if(mainDecodedDataList.count == 0 && self.calledOnce == true){
            checkIfListSizeIsZero()
            return UIImageView(image: UIImage(named: "NoSale"))
        }
        else{
            return UIImageView(image: UIImage(named: "GGCard"))
        }
    }
    
    
    
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        print("[koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? ]")
        
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}
