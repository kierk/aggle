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
    var _from : String
    var _date : NSDate
    var _to : String
    var _item : Item
    
    init(text: String?, from: String?, to: String?, item: Item?) {
        self._text = text!
        self._from = from!
        self._to = to!
        self._date = NSDate()
        self._item = item!
    }
    
    func text() -> String! {
        return _text;
    }
    
    func from() -> String! {
        return _from;
    }
    
    func to() -> String! {
        return _to;
    }
    
    func date() -> NSDate! {
        return _date;
    }
    
    func item() -> Item? {
        return _item;
    }
}