//
//  ShoppingItem.swift
//  MyShop
//
//  Created by Apple on 26/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation

class ShoppingDetail {
    
    var name: String
    var info: String
    var quantity: String
    var price: Float
    var shoppingItemId: String
    var ShoppingListId: String
    var isBought: Bool
    var image: String
    
    init(_name: String, _info: String = "", _quantity: String = "1", _price: Float, _shoppingListId: String) {
        
        name = _name
        info = _info
        quantity = _quantity
        price = _price
        shoppingItemId = ""
        ShoppingListId = _shoppingListId
        isBought = false
        image = ""
    }
    
    init(dictionary: NSDictionary) {
        
        name = dictionary[kNAME] as! String
        info = dictionary[kINFO] as! String
        quantity = dictionary[kQUANTITY] as! String
        price = dictionary[kPRICE] as! Float
        shoppingItemId = dictionary[kSHOPPINGITEMID] as! String
        ShoppingListId = dictionary[kSHOPPINGLISTID] as! String
        isBought = dictionary[kISBOUGHT] as! Bool
        image = dictionary[kIMAGE] as! String
        
    }
//    func dictionaryFromItem(item: ShoppingList) -> NSDictionary {
//
//        return NSDictionary(objects: [item.name, item.totalPrice, item.totalItems, item.id, dateFormatter().string(from: item.date), item.ownerId], forKeys: [kNAME as NSCopying, kTOTALPRICE as NSCopying, kTOTALITEMS as NSCopying, kSHOPPINGITEMID as NSCopying, kDATE as NSCopying, kOWNERID as NSCopying])
//    }
//
//    func saveItemsInBackground(shoppingList: ShoppingList, completion: @escaping (_ error: Error? ) -> Void) {
//
//
//        let ref = firebase.child(kSHOPPINGLIST).child("1234").childByAutoId()
//
//        shoppingList.id = ref.key!
//
//        ref.setValue(dictionaryFromItem(item: shoppingList)) {(error, ref) -> Void in
//
//            completion(error)
//        }
//    }
//    func delteItemInBackground(shoppinList: ShoppingList) {
//
//        let ref = firebase.child(kSHOPPINGLIST).child("1234").child(shoppinList.id)
//        ref.removeValue()
//    }
//}
}
