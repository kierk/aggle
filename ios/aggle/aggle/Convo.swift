//
//  Convo.swift
//  aggle
//
//  Convo vanilla object
//
//  Created by Max Li on 4/19/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import Foundation

class Convo {
    var _messages = [Message]()
    var _item : Item
    var _id : String
    
    init(id: String?, messages: [Message]?, item: Item?) {
        self._messages = messages!
        self._item = item!
        self._id = id!
    }
    
    func messages() -> [Message]! {
        return _messages;
    }
    
    func item() -> Item! {
        return _item;
    }

    func id() -> String! {
        return _id;
    }
    
    func addMessage(message: Message) {
        _messages.append(message)
    }
}