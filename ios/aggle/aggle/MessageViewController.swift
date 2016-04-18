//
//  MessageViewController.swift
//  aggle
//
//  Created by Max Li on 4/10/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
class MessageViewController: JSQMessagesViewController {

    
    @IBOutlet weak var showImage: UIImageView!
    
    
    //@IBOutlet var showImage: UIImageView!
    //let imageRef = Firebase(url: "https://aggle.firebaseio.com/items_for_sale")
    let rootRef = Firebase(url:"https://aggle.firebaseio.com/")
    var messageRef: Firebase!
    
    var ref = Firebase(url:"https://aggle.firebaseio.com/")
    
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        self.senderId = ref.authData.uid
        self.senderDisplayName = "Jose"
        setupBubbles()
        messageRef = rootRef.childByAppendingPath("messages")
        
        // not sure what these are supposed to do, they give an error whenever I run them
        
        //collectionView!.collectionViewLayout.incomingAvatarViewSize =
        //collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        //collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        print(ref.authData.uid)
        print("[viewDidLoad] hi")
        
        
        
        super.viewDidLoad()
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(MessageViewController.setBttnTouched(_:)))
        }
    
    
        override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
            return messages[indexPath.item]
        }
    
        override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return messages.count
        }
    
        private func setupBubbles() {
            let factory = JSQMessagesBubbleImageFactory()
            outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
            incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
        }
    
    
        override func collectionView(collectionView: JSQMessagesCollectionView!,
                                     messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
            let message = messages[indexPath.item] // 1
            if message.senderId == senderId { // 2
                return outgoingBubbleImageView
            } else { // 3
                return incomingBubbleImageView
            }
        }
    
        override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
            return nil
        }
    
    
    
        func addMessage(id: String, text: String) {
            let message = JSQMessage(senderId: id, displayName: "", text: text)
            messages.append(message)
        }
    
    
    
        //When send button is pressed, this adds the message to the database.
        override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,senderDisplayName: String!, date: NSDate!) {
            
            let itemRef = messageRef.childByAutoId() // 1
            let messageItem = [ // 2
                "text": text,
                "senderId": senderId
            ]
            itemRef.setValue(messageItem) // 3
            
            // 4
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
            // 5
            finishSendingMessage()
        }
    
    
    
        // this changes the text color in the textbubbles
        override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
                as! JSQMessagesCollectionViewCell
        
            let message = messages[indexPath.item]
        
            if message.senderId == senderId {
                cell.textView!.textColor = UIColor.whiteColor()
            } else {
                cell.textView!.textColor = UIColor.blackColor()
            }
        
        return cell
    }
        
        

//        
//        let imageRef = Firebase(url: "https://aggle.firebaseio.com/items_for_sale")
//        
//        
////        var myimage = UIImage(named : "crock_20")
////        showImage.image = myimage
////        view.addSubview(self.showImage)
//        
//        
//        
//        
//        imageRef.observeEventType(.ChildAdded, withBlock: {snapshot in
//            print("heyyyy ChildAdded")
//            
//            
//            var imageEncodedData = String(snapshot.value.objectForKey("pic_base64")!)
//            
//            
//            //let url = NSURL(URLWithString)
//            //print(imageEncodedData)
//            
//            let decodedData = NSData(base64EncodedString: imageEncodedData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
//            //print(decodedData)
//            
//  
//            
//            
//            if decodedData != nil{
//                print("in decoding data")
//                let image = UIImage(data: decodedData!)
//                
//                self.showImage.image = image as UIImage!
//            }
//        })
    
    
    
    
    func setBttnTouched(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("convoSettingsSegue", sender: self)
        
    }
    
}


        //self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    
    


//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


    
    
    
    
    
    
    
    


