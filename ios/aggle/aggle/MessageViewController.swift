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
    
    
    let rootRef = Firebase(url:"https://aggle.firebaseio.com/")
    var messageRef: Firebase!
    
    
    var ref = Firebase(url:"https://aggle.firebaseio.com/")
    
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    
    override func viewDidLoad() {
        print("[viewDidLoad] hi")
        
        self.senderId = ref.authData.uid!
        self.senderDisplayName = String((ref.authData.providerData["displayName"])!)
        setupBubbles()
        messageRef = rootRef.childByAppendingPath("ConvoDB")
        
        super.viewDidLoad()
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(MessageViewController.setBttnTouched(_:)))
        }
    
    
        override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            observeMessages()
        }
    
    
    
    // next two functions handle names above the text bubbles
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        
        //if message.senderId == self.senderId {
        //    return nil;
        //}
        
        // Same as previous sender, skip
//        if indexPath.item > 0 {
//            let previousMessage = messages[indexPath.item - 1];
//            if previousMessage.senderId == message.senderId
//            {
//                return nil;
//            }
//        }
        
        return NSAttributedString(string:message.senderDisplayName)
    }
    
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
//        // Sent by me, skip
//        if message.senderId == self.senderId {
//            return CGFloat(0.0);
//        }
//        
//        // Same as previous sender, skip
//        if indexPath.item > 0 {
//            let previousMessage = messages[indexPath.item - 1];
//            if previousMessage.senderId == message.senderId {
//                return CGFloat(0.0);
//            }
//        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
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
    
    
    
    func addMessage(id: String, displayName: String, date : NSDate, text : String ) {
        let message = JSQMessage(senderId: id, senderDisplayName: displayName, date: date, text: text)
            messages.append(message)
        
        }
    
    
    
    override func didPressAccessoryButton(sender: UIButton!) {
        <#code#>
    }
    
    
        //When send button is pressed, this adds the message to the database.
    
        override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,senderDisplayName: String!, date: NSDate!) {
            
            
            
            //let uniqueID = messageRef.childByAutoId()
            //let itemRef = messageRef.childByAutoId() // 1
            let messageItem = [ // 2
                "text": text,
                "senderId": senderId
            ]
         
            
            let convoRef = ref.childByAppendingPath("UsersDB/" + (self.senderId) + "/" + "Conversations") // path for Users conversation table
            let messageReff = convoRef.childByAutoId() // generates a unique id for each conversation that a user has had
            
            let convoDB = ref.childByAppendingPath("ConvoDB/")
            
            let convoDB_ref = convoDB.childByAutoId()
            
            let ConvoInfo = [
                "itemID": "itemID",
                "Messages" : ["date" : String(date), "from" : self.senderId, "text" : text, "to" : "someone", "name": self.senderDisplayName]
            ]
            
            convoDB_ref.setValue(ConvoInfo)
            //messageReff.setValue(messageItem)
            messageReff.updateChildValues(messageItem)
            
            self.messageRef = convoDB_ref.childByAppendingPath("Messages/")
            print("up here")
            print(self.messageRef)
            
            
            // 4
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
            // 5
            finishSendingMessage()
        }
    
    
    
    
    
    
    
        
    
    // this will query messages from the db and update them in the chat screen
        private func observeMessages() {
            // 1
            
            
            //let messagesQuery = self.messageRef.childByAppendingPath("Messages").queryLimitedToLast(25)
            let messagesQuery = self.messageRef.queryLimitedToLast(25)
            // 2
            print("hereeeee")
            if(self.messageRef != nil){
                print(self.messageRef)
            }
            print(messagesQuery.description)
            //messagesQuery.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
           
            messagesQuery.observeEventType(.ChildAdded, withBlock: { snapshot in
            // 3
                print(snapshot.description)
                let temp1 = snapshot.value
                print(temp1)
                let id = snapshot.childSnapshotForPath("Messages").value["from"] as! String
                print("printing")
                print(self.senderDisplayName)
                //print(snapshot.value.objectForKey("Messages/date"))
                //let id = "sam"
                //let temp = snapshot.childSnapshotForPath("Messages").value["text"]!!.description
                let text = snapshot.childSnapshotForPath("Messages").value["text"] as! String
                let displayName = self.senderDisplayName as! String
                //let text = "haha"
                // 4
                
                let myDate = NSDate()
                
                self.addMessage(id, displayName: displayName, date: myDate, text: text)
               // self.addMessage(<#T##id: String##String#>, text: <#T##String#>, displayName: <#T##String#>, date: <#T##NSDate#>, media: <#T##JSQMessageMediaData#>)
            
                // 5
                self.finishReceivingMessage()
            })
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


    
    
    
    
    
    
    
    


