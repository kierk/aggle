//
//  MessageViewController.swift
//  aggle
//
//  This controller SHOULD display a single conversation about an item, between 2 peoples
//  It should be renamed ConvoViewController
//
//  Created by Max Li on 4/10/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class MessageViewController: JSQMessagesViewController {
    var TAG: String = "[MessageViewController]"

    @IBOutlet weak var showImage: UIImageView!

    var convo: Convo!
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    let rootRef = Firebase(url:"https://aggle.firebaseio.com/")
    var messagesRef: Firebase!

    override func viewDidLoad() {
        print(TAG + "[viewDidLoad] hi")
        super.viewDidLoad()
        
        /* Set up the top settings bar */
        self.inputToolbar.contentView.leftBarButtonItem = nil // Disable the ability to upload images. TODO(eugenek): Renable it.
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(MessageViewController.setBttnTouched(_:)))
        
        /* Set up the scene, load the appropriate data */
        self.senderId = rootRef.authData.uid!
        self.senderDisplayName = String((rootRef.authData.providerData["displayName"])!)
        self.messagesRef = rootRef.childByAppendingPath("ConvoDB/" + convo.id() + "/Messages")

        
        /* Set up the message bubbles to be nice and pretty */
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Load and display the messages */
        observeMessages()
    }
    
    
    /**
     * Update the display text associated with a message bubble */
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by sender, don't display name
        if message.senderId == self.senderId {
            return nil;
        }
        
        return NSAttributedString(string:message.senderDisplayName)
    }
    
    /**
     * Update the size of the message bubble associated w/ am essage */
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item];
        
        // Sent by sender, don't display name
        if message.senderId == self.senderId {
            return CGFloat(0.0);
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    /**
    * Return the message selected */
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    /** 
    * Return the number of messages on the screen */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    /**
     * Return the type of message bubble to display. Sender and receiver gets their own message bubble style, based on their perspective. */
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    /**
    * Return each message user's avatar. */
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    /**
    * When the upload button is pressed, this lets the user upload something and share it. 
    * eugenek: DOES NOT WORK AS OF APRIL 24, 2016 */
    override func didPressAccessoryButton(sender: UIButton!) {
        print(TAG + "didPressAccessoryButton")
        var picker: UIImagePickerController = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        self.presentViewController(picker, animated: true, completion: { _ in })
    }
    
    /**
     * When send button is pressed, this adds the message to the database. */
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,senderDisplayName: String!, date: NSDate!) {
        print(TAG + "didPressSendButton")
        
        let messageItem = [
            "text": text,
            "senderId": senderId,
            "date": String(date.timeIntervalSince1970),
            "senderDisplayName": senderDisplayName
        ]
        
        messagesRef.childByAutoId().setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    /**
     * Query messages from the db and update them in the conversation */
    private func observeMessages() {
        print(TAG + "observeMessages")
        //let messagesQuery = self.messageRef.queryLimitedToLast(25)
        
        messagesRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            print(self.TAG + "we just observed a new message!")
            print(self.TAG + snapshot.description)
            
            let senderId = snapshot.value["senderId"] as! String
            let text = snapshot.value["text"] as! String
            let senderDisplayName = snapshot.value["senderDisplayName"] as! String
            let date = snapshot.value["date"] as! String
            let message = JSQMessage(senderId: senderId,
                senderDisplayName: senderDisplayName,
                date: NSDate(timeIntervalSince1970: Double(date)!),
                text: text)
            
            self.messages.append(message)
            
            self.finishReceivingMessage()
        })
    }
    
    /**
    * Send the user to the settings */
    func setBttnTouched(sender: UIBarButtonItem) {
        performSegueWithIdentifier("messageSettingsSegue", sender: self)
    }
    
}









