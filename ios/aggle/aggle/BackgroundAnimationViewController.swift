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
    
    
    let rootRef = Firebase(url:"https://aggle.firebaseio.com/")
    var zipCode = "10029"
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        //self.zipCode = User.sharedInstance.zip
        //print(self.zipCode)
        pullValuesFromDB()
        
        
        
    }
    
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        print("[@IBAction func leftButtonTapped()]")
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        print("[@IBAction func rightButtonTapped()]")
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        print("[@IBAction func undoButtonTapped()]")
        kolodaView?.revertAction()
    }
    
    
    
    // this gets the encoded images from firebase
    func pullValuesFromDB(){
        let picRef = rootRef.childByAppendingPath("ZipDB/" + self.zipCode)
         picRef.queryLimitedToLast(25).observeEventType(.ChildAdded, withBlock: {snapshot in
            let temp = snapshot.value
             if let encodedString = temp.valueForKey("base64Encoding"){
                self.base64decode(encodedString as! String)
            }
            
        })
    }
    
    // this decodes them and stores them in a list
    func base64decode(encodedString : String){
        var decodedDataList = [NSData]()
        
       if let decodedData = NSData(base64EncodedString: encodedString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters){
                decodedDataList.append(decodedData)
                mainDecodedDataList.append(decodedData)
        }
    }
    
    
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        print("[kolodaDidRunOutOfCards]")
        kolodaView.resetCurrentCardIndex()
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
        print("[kolodaShouldMoveBackgroundCard(koloda: KolodaView)]")
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
    
    // this one has to do with moving to new cards
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        print("[koloda(koloda: KolodaView, viewForCardAtIndex index: UInt)]")
        
        
        if let userConstants = NSUserDefaults.standardUserDefaults().objectForKey(rootRef.authData.uid){
            print("in koloda swipe, id is  \(userConstants[0])")
            print("in koloda swipe, zipCode is  \(userConstants[1])")
            print("in koloda swipe displayname is  \(userConstants[2])")
        }
        
        
        
        
        //return UIImageView(image: UIImage(named: "cards_\(index + 1)"))
        
        if((mainDecodedDataList.count > 0)){
            return UIImageView(image: UIImage(data: mainDecodedDataList[0]))
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
