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
import JSQMessagesViewController

class Convo {
    var _messages = [Message]()
    var _item : Item
    
    init(messages: [Message]?, item: Item?) {
        self._messages = messages!
        self._item = item!
    }
    
    func messages() -> [Message]! {
        return _messages;
    }
    
    func item() -> Item! {
        return _item;
    }

    func addMessage(message: Message) {
        _messages.append(message)
    }
}