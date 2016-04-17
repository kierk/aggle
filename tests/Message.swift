import Foundation

class Message : NSObject, JSQMessageData {
    var _text : String
    var _from : String
    var _date : NSDate
    var _to : String
    var _item : Item

    convenience init(text: String?, from: String?, to: String?, item: Item?) {
        self.init(text: text, from: from, to: to, item: item)
    }

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
