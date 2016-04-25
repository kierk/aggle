//
//  Message.swift
//  aggle
//
//  Created by Kolodenker, Eugene on 4/24/16.
//  Copyright © 2016 Aggle. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class Message : NSObject {
    var _text : String
    var _senderId : String
    var _senderDisplayName : String
    var _date : NSDate
    
    init(text: String?, senderId: String?, senderDisplayName: String?) {
        self._text = text!
        self._senderId = senderId!
        self._senderDisplayName = senderDisplayName!
        self._date = NSDate()
    }
    
    init(text: String?, senderId: String?, senderDisplayName: String?, date: NSDate?) {
        self._text = text!
        self._senderId = senderId!
        self._senderDisplayName = senderDisplayName!
        self._date = date!
    }
    
    func text() -> String! {
        return _text;
    }
    
    func senderId() -> String! {
        return _senderId;
    }
    
    func senderDisplayName() -> String! {
        return _senderDisplayName;
    }
    
    func date() -> NSDate! {
        return _date;
    }
}