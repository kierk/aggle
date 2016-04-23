//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
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


class BackgroundAnimationViewController: UIViewController {
    
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    var calledOnce = false
    
    var startAtRef = ""
    let rootRef = Firebase(url:"https://aggle.firebaseio.com/")
    var zipCode : String = "00000"
    var size : Int = 0
    
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        print("STARTING\n")
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
            print("mainZip is")
            print(self.zipCode)
            
        }
        
        //let tempZipCode = User.sharedInstance.zip
        pullValuesFromDB(self.zipCode)
        
//        
//        if let object = (NSUserDefaults.standardUserDefaults().objectForKey(userID))?.valueForKey("ZipCode"){
//            self.zipCode = object as! String
//            print("\n\ncalling pullValuesFromDB in viewDidLoad, first show zipcode\n\n")
//            print(self.zipCode)
//            pullValuesFromDB(self.zipCode)
//        }
        
        
        
        
    }
    
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        //print("[@IBAction func leftButtonTapped()]")
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        //print("[@IBAction func rightButtonTapped()]")
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        //print("[@IBAction func undoButtonTapped()]")
        kolodaView?.revertAction()
    }
    
    
    
    
    
    // this gets the encoded images from firebase
    
    func checkIfListSizeIsZero() -> Void{
        if mainDecodedDataList.count == 0{
            pullValuesFromDB(self.zipCode)
        }
        self.calledOnce = false
    }
    
    
    
    
    func pullValuesFromDB(zipCode : String){
        
        let currentUserZipCodeRef = rootRef.childByAppendingPath("ZipDB/" + self.zipCode)
        
        print("\n[pullValuesFromDB]\n")
        print(self.zipCode)
        currentUserZipCodeRef.queryLimitedToFirst(3).observeSingleEventOfType(.Value, withBlock: {zipKeys in
            
            for zipKeys in zipKeys.children{
                print("Loading keys \(zipKeys.key)")
                
                if let temp = (zipKeys).value.objectForKey("base64Encoding"){
                    print("higher hey")
                    if(((zipKeys).value.objectForKey("OwnerID")) as! String != self.rootRef.authData.uid){
                        self.base64decode(temp as! String)
                        print("hey there")
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
    func base64decode(encodedString : String){
        var decodedDataList = [NSData]()
        
       if let decodedData = NSData(base64EncodedString: encodedString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters){
                decodedDataList.append(decodedData)
                mainDecodedDataList.append(decodedData)
        }
        
        self.size = decodedDataList.count
        self.calledOnce = true
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
        print("[kolodaShouldTransparentizeNextCard(koloda: KolodaView)]")
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
        print("[koloda(koloda: KolodaView, viewForCardAtIndex index: UInt)]")
        
        //kolodaView?.swipe(SwipeResultDirection.Left)
        
         //let main = koloda.swipe(SwipeResultDirection)  //.SwipeResultDirection()
        
        //let left = SwipeResultDirection.Left
        //let right = SwipeResultDirection.Right
        
        
//        if(case  == left){
//            print("\n\nSwiped left\n\n")
//        }
//        
//        else if(case .right == right){
//            print("\n\nswiped right\n\n")
//        }
//        
//        else{
//            print("no direction")
//        }
//        
//        if(left == SwipeResultDirection.Left){
//            print("\n\nSwiped left\n\n")
//        }
//        
//        else{
//            print("\n\nswiped right\n\n")
//        }
        
        
        
        if((mainDecodedDataList.count > 0)){
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
