import Foundation

// TODO(eugenek): Should really OOP this up. and make a User class
// TOOD(eugenek): As well as a Conversation class

class Item : NSObject {
    var _description : String
    var _itemzip : String // TODO(eugenek): Is there a better type for this?, e.g. NSZip(?)
    var _owner : String
    var _pic : String // TODO(eugenek): Is there a better type for this, e.g. UIIimage
    var _price : String // TODO(eugenek): Price type..? Float? NSPrice? Who knows...
    var _soldto : String
    var _date : NSDate

    convenience init(description: String?, itemzip: String?, owner: String?, pic: String?,
      price: String?, soldto: String?) {
        self.init(description: description, itemzip: itemzip, owner: owner, pic: pic, price: price,
          soldto: soldto)
    }

    init(description: String?, itemzip: String?, owner: String?, pic: String?,
      price: String?, soldto: String?) {
        self._description = description!
        self._itemzip = itemzip!
        self._owner = owner!
        self._pic = pic!
        self._price = price!
        self._soldto = soldto!
        self._date = NSDate()
    }

    func _description() -> String! {
        return _description;
    }

    func _itemzip() -> String! {
        return _itemzip;
    }

    func _owner() -> String! {
        return _owner;
    }

    func _pic() -> String? {
        return _pic;
    }

    func _price() -> String? {
        return _price;
    }

    func _soldto() -> String? {
        return _soldto;
    }

    func _date() -> NSDate? {
        return _date;
    }

}
