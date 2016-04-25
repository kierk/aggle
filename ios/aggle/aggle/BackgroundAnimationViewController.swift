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
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


var mainDecodedDataList = [NSData]()
var mainItemIDList = [String]()


class BackgroundAnimationViewController: UIViewController{
    
    let swipeResult = KolodaView()
    
    
//    @IBAction func leftSwipe(sender: UISwipeGestureRecognizer) {
//        print ("\n\nswiped Left\n\n")
//    }
//    
//    @IBAction func rightSwipe(sender: UISwipeGestureRecognizer) {
//        print("\n\nswiped Right\n\n")
//    }
//    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    
    
    var calledOnce = false
    var startAtRef = ""
    let rootRef = Firebase(url:"https://aggle.firebaseio.com/")
    var zipCode : String = "00000"
    var size : Int = 0 // size for decoded data list
    var displayNmae : String = ""
    var itemIDListSize : Int = 0 // size for itemIDlist
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        print("STARTING\n")
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(BackgroundAnimationViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(BackgroundAnimationViewController.handleSwipes(_:)))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        
        
        
        let temp = UITextField()
        
        let userID = rootRef.authData.uid
        super.viewDidLoad()
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
        
        
        pullValuesFromDB(self.zipCode) // the first batch of images are pulled, decoded and added to maindecoded list
                                       // before the first call to the kolodaswipe handler.
        
    }
    

    
    @IBAction func leftButtonSelectorV2(sender: AnyObject?) {
        print("in left button")
        kolodaView?.swipe(SwipeResultDirection.Left)
        
        let userDB = rootRef.childByAppendingPath("UsersDB")
        let userLikes_ref = rootRef.childByAppendingPath("UsersDB/\(rootRef.authData.uid)/DisLikes")
        
        print(userDB)
        print(rootRef.authData.uid)
        print(self.displayNmae)
        print(mainItemIDList.count)
        print(itemIDListSize)
        
        let userID = rootRef.authData.uid
        
        if itemIDListSize > 0{  // check if itemIDList is not empty
            let likedItemID = mainItemIDList.popLast() // assigns the last element of mainItemIDList to
            // likedItemID and removed it from mainItemIDList
            
            print("\n[inLeftButtonAction]\n")
            
            userDB.observeSingleEventOfType(.Value, withBlock: {zipKeys in
                
                for zipKeys in zipKeys.children{
                    
                    //print("Loading keys in right button action click \(zipKeys.key)")
                    //print(zipKeys)
                    
                    if userID == zipKeys.key as String{
                        //print("in the if")
                        
                        var likedInfoDic = [:]
                        
                        likedInfoDic = [likedItemID! : likedItemID!]
                        
                        
                        userLikes_ref.updateChildValues(likedInfoDic as [NSObject : AnyObject])
                    }
                }
            })
        }
    }
    
    @IBAction func rightButtonTapped() {
        
        
        kolodaView?.swipe(SwipeResultDirection.Right)
        
        let userDB = rootRef.childByAppendingPath("UsersDB")
        let userLikes_ref = rootRef.childByAppendingPath("UsersDB/\(rootRef.authData.uid)/Likes")
        
        print(userDB)
        print(rootRef.authData.uid)
        print(self.displayNmae)
        print(mainItemIDList.count)
        print(itemIDListSize)
        
        let userID = rootRef.authData.uid
        
        if itemIDListSize > 0{                          // check if itemIDList is not empty
            let likedItemID = mainItemIDList.popLast() // assigns the last element of mainItemIDList to 
                                                       // likedItemID and removed it from mainItemIDList
            
            print("\n[inRightButtonAction]\n")
            
            userDB.observeSingleEventOfType(.Value, withBlock: {zipKeys in
                
                for zipKeys in zipKeys.children{
                    
                    if userID == zipKeys.key as String{
                        //print("in the if")
                       
                        var likedInfoDic = [:]
                        
                        likedInfoDic = [likedItemID! : likedItemID!]
                        
                        
                        userLikes_ref.updateChildValues(likedInfoDic as [NSObject : AnyObject])
                    }
                }
            })
        }
    }
    
    @IBAction func undoButtonTapped() {
        //print("[@IBAction func undoButtonTapped()]")
        kolodaView?.revertAction()
    }
    
    
    func handleSwipes(sender: UISwipeGestureRecognizer){
        if(sender.direction == .Left){
            leftButtonSelectorV2("swipedLeft")
        }
        
        else{
            rightButtonTapped()
        }
    }
    
    
//    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//        
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            
//            
//            switch swipeGesture.direction {
//            case UISwipeGestureRecognizerDirection.Right:
//                print("Swiped right")
//            case UISwipeGestureRecognizerDirection.Down:
//                print("Swiped down")
//            case UISwipeGestureRecognizerDirection.Left:
//                print("Swiped left")
//            case UISwipeGestureRecognizerDirection.Up:
//                print("Swiped up")
//            default:
//                break
//            }
//        }
//    }
    
    
    // this gets the encoded images from firebase
    
    func checkIfListSizeIsZero() -> Void{
        if mainDecodedDataList.count == 0{
            pullValuesFromDB(self.zipCode)
        }
        self.calledOnce = false
    }
    
    
    
    
    func pullValuesFromDB(zipCode : String){
        let currentUserZipCodeRef = rootRef.childByAppendingPath("ZipDB/" + self.zipCode)

        currentUserZipCodeRef.queryLimitedToLast(25).observeSingleEventOfType(.Value, withBlock: {zipKeys in
            
            for zipKeys in zipKeys.children{
                
                let tempOwner = (zipKeys).value.objectForKey("OwnerID") as! String
                
                if let base64EncodedString = (zipKeys).value.objectForKey("base64Encoding"){
                    if let myItemID = (zipKeys).value.objectForKey("ItemID"){
                        if((((zipKeys).value.objectForKey("OwnerID")) as! String) != self.rootRef.authData.uid){
                                print(tempOwner)  // should not be user that is logged in
                                self.base64decode(base64EncodedString as! String, itemID: myItemID as! String)
                            
                            }
                        
                    }
                }
            }
        })
    }

    
//    func pullValuesFromDB(zipCode : String){
//        
//        let currentUserZipCodeRef = rootRef.childByAppendingPath("ZipDB/" + self.zipCode)
//        
//        print("\n[pullValuesFromDB]\n")
//        print(self.zipCode)
//        
//        var checkerBool = false
//        
//        if checkerBool == true{
//            
//        }
//        
//         currentUserZipCodeRef.queryOrderedByKey().queryLimitedToFirst(3).observeSingleEventOfType(.Value, withBlock: {zipKeys in
//            var count = 0
//            
//            for zipKeys in zipKeys.children{
//                print("Loading keys \(zipKeys.key)")
//                
//                currentUserZipCodeRef.childByAppendingPath(zipKeys as! String).queryStartingAtValue(zipKeys as! String)
//                
//                let zipKeyIterator = zipKeys
//                
//                if let temp = (zipKeys).value.objectForKey("base64Encoding"){
//                    print("higher hey")
//                    
//                    if(((zipKeys).value.objectForKey("OwnerID")) as! String != self.rootRef.authData.uid){
//                        
//                        
//                        count += 1
//                        self.base64decode(temp as! String)
//                        if(count == 3){
//                            var innerCount = 0
//                            currentUserZipCodeRef.childByAppendingPath(zipKeys as! String).queryStartingAtValue(zipKeys as! String).queryLimitedToFirst(2).observeSingleEventOfType(.Value, withBlock: {testZipKeys in
//                                    print("here")
//                                    let temp = String(testZipKeys)
//                                    innerCount += 1
//                                if(innerCount == 2){
//                                    self.startAtRef = temp
//                                }
//                            })
//                        }
//                    }
//                }
//            }
//        })
//    }
    
    
    // this decodes them and stores them in a list
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
        UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
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
            return UIImageView(image: UIImage(named: "cards_\(index + 1)"))
        }
        else{
            
            return UIImageView(image: UIImage(named: "cards_\(index + 1)"))
        }

    }
    
    
    
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        print("[koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? ]")
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
}
