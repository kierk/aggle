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
    var TAG: String = "[MessageViewController]"
    
    override func viewDidLoad() {
        print(TAG + "[viewDidLoad] hi")
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
    
    /**
     * Update the display text associated with a message bubble
     */
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by sender, don't display name
        if message.senderId == self.senderId {
            return nil;
        }
        
        return NSAttributedString(string:message.senderDisplayName)
    }
    
    /**
     * Update the size of the message bubble associated w/ am essage
     */
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item];
        
        // Sent by sender, don't display name
        if message.senderId == self.senderId {
            return CGFloat(0.0);
        }
        
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
    
    /**
     * Change color(and other properties) of sender and receiver's message bubbles to their specific ones
     */
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    func addMessage(id: String, displayName: String, date : NSDate, text : String ) {
        print(TAG + "addMessage")
        let message = JSQMessage(senderId: id, senderDisplayName: displayName, date: date, text: text)
        messages.append(message)
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print(TAG + "didPressAccessoryButton")
        var picker: UIImagePickerController = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        self.presentViewController(picker, animated: true, completion: { _ in })
    }
    
    /*
     * When send button is pressed, this adds the message to the database.
     **/
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,senderDisplayName: String!, date: NSDate!) {
        print(TAG + "didPressSendButton")
        
        let messageItem = [
            "text": text,
            "senderId": senderId
        ]
        
        let convoRef = ref.childByAppendingPath("UsersDB/" + (self.senderId) + "/" + "Conversations")
        let messageRef = convoRef.childByAutoId() // generates a unique id for each conversation that a user has had
        let convoDB = ref.childByAppendingPath("ConvoDB/")
        let convoDBref = convoDB.childByAutoId()
        
        let ConvoInfo = [
            "itemID": "itemID",
            "Messages" : ["date" : String(date), "from" : self.senderId, "text" : text, "to" : "someone", "name": self.senderDisplayName]
        ]
        
        convoDBref.setValue(ConvoInfo)
        messageRef.updateChildValues(messageItem)
        
        self.messageRef = convoDBref.childByAppendingPath("Messages/")
        print(self.messageRef)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    /** observeMessages
     * Query messages from the db and update them in the conversation
     */
    private func observeMessages() {
        print(TAG + "observeMessages")
        let messagesQuery = self.messageRef.queryLimitedToLast(25)
        
        print(TAG + messagesQuery.description)
        messagesQuery.observeEventType(.ChildAdded, withBlock: { snapshot in
            print(self.TAG + snapshot.description)
            let id = snapshot.childSnapshotForPath("Messages").value["from"] as! String
            let text = snapshot.childSnapshotForPath("Messages").value["text"] as! String
            let displayName = self.senderDisplayName as! String
            
            let myDate = NSDate()
            
            self.addMessage(id, displayName: displayName, date: myDate, text: text)
            
            self.finishReceivingMessage()
        })
    }
    
    func setBttnTouched(sender: UIBarButtonItem) {
        performSegueWithIdentifier("convoSettingsSegue", sender: self)
    }
    
}

/* Some snippets that might help */
//self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
//self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
//self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]












