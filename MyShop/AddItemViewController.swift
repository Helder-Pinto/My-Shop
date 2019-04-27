//
//  AddItemViewController.swift
//  MyShop
//
//  Created by Apple on 26/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddItemViewController: UIViewController {
    
    
    var shoppingList: ShoppingList!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var extraInfoField: UITextField!
    @IBOutlet weak var nameTextFiield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    //MARK: IBAction
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if nameTextFiield.text  != "" && priceField.text != "" {
            
            saveItem()
            
        } else {
            
            SVProgressHUD.showError(withStatus: "Empty fields!")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
 
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Saving Item
    
    func saveItem() {
        
        let shoppingItem = ShoppingDetail(_name: nameTextFiield.text!, _info: extraInfoField.text!, _quantity: quantityField.text!, _price: Float( priceField.text!)!, _shoppingListId: shoppingList.id)
     
        shoppingItem.saveItemsInBackground(shoppingItem: shoppingItem) { (error) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: "Error saving shopping item")
                return 
            }
        }
        
    }
    
}
