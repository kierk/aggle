//
//  Item.swift
//  aggle
//
//  Created by Kolodenker, Eugene on 4/24/16.
//  Copyright © 2016 Aggle. All rights reserved.
//

import Foundation

class Item : NSObject {
    var _title : String
    var _description : String
    var _itemzip : String // TODO(eugenek): Is there a better type for this?, e.g. NSZip(?)
    var _owner : String
    var _pic : String // TODO(eugenek): Is there a better type for this, e.g. UIIimage
    var _price : String // TODO(eugenek): Price type..? Float? NSPrice? Who knows...
    var _soldto : String
    var _date : NSDate
    
    init(title: String?, description: String?, itemzip: String?, owner: String?, pic: String?,
         price: String?, soldto: String?) {
        self._title = title!
        self._description = description!
        self._itemzip = itemzip!
        self._owner = owner!
        self._pic = pic!
        self._price = price!
        self._soldto = soldto!
        self._date = NSDate()
    }
    
    func title() -> String! {
        return _title;
    }
    
    func desc() -> String! { // TODO(eugenek): the name 'description' is taken by NSObject, don't feel like figure that shit out.
        return _description;
    }
    
    func itemzip() -> String! {
        return _itemzip;
    }
    
    func owner() -> String! {
        return _owner;
    }
    
    func pic() -> String? {
        return _pic;
    }
    
    func price() -> String? {
        return _price;
    }
    
    func soldto() -> String? {
        return _soldto;
    }
    
    func date() -> NSDate? {
        return _date;
    }
    
}