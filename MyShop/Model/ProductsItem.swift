//
//  ProductsItem.swift
//  MyShop
//
//  Created by Apple on 27/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//
import Foundation

class GroceryItem {
    
    var name: String
    var info: String
    var price: Float
    let ownerId: String
    var image: String
    var groceryItemId: String
    
    init(_name: String, _info: String = "", _price: Float, _image: String = "") {
        
        self.name = _name
        self.info = _info
        self.price = _price
        self.ownerId = "1234"
        self.image = _image
        self.groceryItemId = ""
    }
    
    init(dictionary: NSDictionary) {
        
        self.name = dictionary[kNAME] as! String
        self.info = dictionary[kINFO] as! String
        self.price = dictionary[kPRICE] as! Float
        self.ownerId = dictionary[kOWNERID] as! String
        self.image = dictionary[kIMAGE] as! String
        self.groceryItemId = dictionary[kGROCERYITEMID] as! String
    }
    
    init(shoppingItem: ShoppingDetail) {
        
        self.name = shoppingItem.name
        self.info = shoppingItem.info
        self.price = shoppingItem.price
        self.ownerId = "1234"
        self.image = shoppingItem.image
        self.groceryItemId = ""
        
    }
    
    func dictionaryFromItem(item: GroceryItem) -> NSDictionary {
        
        return NSDictionary(objects: [item.name, item.info, item.price, item.ownerId, item.image, item.groceryItemId], forKeys: [kNAME as NSCopying, kINFO as NSCopying, kPRICE as NSCopying, kOWNERID as NSCopying, kIMAGE as NSCopying, kGROCERYITEMID as NSCopying])
    }
    
    
    func saveItemInBackground(groceryItem: GroceryItem, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kGROCERYITEM).child("1234").childByAutoId()
        
        groceryItem.groceryItemId = ref.key!
        
        
        ref.setValue(dictionaryFromItem(item: groceryItem)) { (error, ref) -> Void in
            
            completion(error)
            
        }
        
    }
    
    
    func updateItemInBackground(groceryItem: GroceryItem, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kGROCERYITEM).child("1234").child(groceryItem.groceryItemId)
        
        ref.setValue(dictionaryFromItem(item: groceryItem)) { (error, ref) -> Void in
            
            completion(error)
            
        }
        
    }
    
    func deleteItemInBackground(groceryItem: GroceryItem) {
        
        let ref = firebase.child(kGROCERYITEM).child("1234").child(groceryItem.groceryItemId)
        ref.removeValue()
        
    }
    
    
}
