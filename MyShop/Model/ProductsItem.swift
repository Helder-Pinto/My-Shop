//
//  ProductsItem.swift
//  MyShop
//
//  Created by Apple on 27/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation

class ProductsItem {
    
    var name: String
    var info: String
    var price: Float
    let ownerId: String
    var image: String
    var groceryItemId: String
    
    
    init(_name: String, _info: String = "", _price: Float, _image: String = ""){
        
        
         name = _name
         info = _info
         price = _price
         ownerId =  "1234"
         image = _image
         groceryItemId = ""
    }
    
    init(dictionary: NSDictionary) {
        
        name = dictionary[kNAME] as! String
        info = dictionary[kINFO] as! String
        price = dictionary[kPRICE] as! Float
        ownerId = dictionary[kOWNERID] as! String
        image = dictionary[kIMAGE] as! String
        groceryItemId = dictionary[kGROCERYITEM] as! String
        
    }
    
    func dictionaryFromItem(item: ProductsItem) -> NSDictionary {
        
        return NSDictionary(objects: [item.name, item.info, item.price, item.ownerId,  item.image, item.groceryItemId], forKeys: [kNAME as NSCopying, kINFO as NSCopying, kPRICE as NSCopying, kOWNERID as NSCopying, kSHOPPINGLISTID as NSCopying, kIMAGE as NSCopying, kGROCERYITEM as NSCopying])
    }
    
    func saveItemsInBackground(groceryItem: ProductsItem, completion: @escaping (_ error: Error? ) -> Void) {
        
        
        let ref = firebase.child(kGROCERYITEM).child("1234").childByAutoId()
        
        groceryItem.groceryItemId = ref.key!
        
        ref.setValue(dictionaryFromItem(item: groceryItem)) {(error, ref) -> Void in
            
            completion(error)
        }
    }
    
    func updateItemInBackground(groceryItem: ProductsItem, completion: @escaping (_ error: Error? ) -> Void) {
        
        let ref = firebase.child(kGROCERYITEM).child("1234").child(groceryItem.groceryItemId)
        
        ref.setValue(dictionaryFromItem(item: groceryItem)){
            error, ref  in
            
            completion(error)
        }
    }
    
    func deleteItemInBackground(groceryItem: ProductsItem) {
        
        let ref = firebase.child(kGROCERYITEM).child("1234").child(groceryItem.groceryItemId)
        ref.removeValue()
    }

}
