//
//  fUser.swift
//  MyShop
//
//  Created by Apple on 28/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import SVProgressHUD

class FUser {
    
    let objectId: String
    let createdAt: Date
    
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    
    init(objectId: String, createdAt: Date, email: String, firstName: String, lastName: String){
        
        self.objectId = objectId
        self.createdAt = createdAt
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
    }
    
    init(_dictionary: NSDictionary) {
        
        
         objectId = _dictionary[kOBJECTID] as! String
         createdAt = dateFormatter().date(from: _dictionary[kCREATEDAT] as! String)!
        
         email = _dictionary[kEMAIL] as! String
         firstName = _dictionary[kFIRSTNAME] as! String
         lastName = _dictionary[kLASTNAME] as! String
         fullName = _dictionary[kFULLNAME] as! String
        
    }
    
    //MARK: Returning current user function
    
    class func currentId() -> String {
        
        return Auth.auth().currentUser!.uid
        
    }
    
    class func currentUser () -> FUser? {
        
        if Auth.auth().currentUser != nil {
            
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                
                return FUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
        
    }
    
    
    //MARK: Login and Register functions
    
//
//    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
//
//        Auth.auth().signIn(withEmail: email, password: password, completion: { (firUser, error) in
//
//            if error != nil {
//                completion(error)
//                return
//            }
//
//            //fetchUser(userId: firUser!.uid, withBlock: { (success) in
//
//            completion(error)
//        })
//
//    }
//
//    class func registerUserWith(email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ error: Error?) -> Void){
//
//        Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
//            if error != nil {
//                completion(error)
//                return
//            }
//            let fUser  = FUser(objectId: firUser.uid, createdAt: <#T##Date#>, email: <#T##String#>, firstName: <#T##String#>, lastName: <#T##String#>)
//        }
//    }
    
}
