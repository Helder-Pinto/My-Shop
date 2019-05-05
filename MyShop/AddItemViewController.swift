//
//  AddItemViewController.swift
//  MyShop
//
//  Created by Apple on 26/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var shoppingList: ShoppingList!
    var itemImage: UIImage?
    var shoppingToEditItem: ShoppingDetail?
    var addingToList: Bool?
    var grocItem: GroceryItem?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var extraInfoField: UITextField!
    @IBOutlet weak var nameTextFiield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(shoppingToEditItem!.name)
        
        let image = UIImage(named: "ShoppingCartEmpty")
        
        
        if shoppingToEditItem != nil || grocItem != nil {
            
            updateItemDetail()
        }

        
    }
    
    
    //MARK: IBAction
    
    @IBAction func imageBtnPressed(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = Camera(delegate_: self)
        
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert) in
            
            camera.PresentPhotoCamera(target: self, canEdit: true)
            
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert) in
            
            camera.PresentPhotoLibrary(target: self, canEdit: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if nameTextFiield.text  != "" && priceField.text != "" {
            
            if shoppingToEditItem != nil || grocItem != nil {
                
                self.updateEditedItem()
                self.dismiss(animated: true, completion: nil)
                
            } else{
                saveItem()
            }
            
            
        } else {
            
            SVProgressHUD.showError(withStatus: "Empty fields!")
        }
    }
    
 
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Saving Item - background
    
    func updateEditedItem() {
        
        var imageData: String!
        if itemImage != nil {
            let image = itemImage?.jpegData(compressionQuality: 0.5)
            imageData = image?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        }else {
            imageData = ""
        }
        
        if shoppingToEditItem != nil {
            shoppingToEditItem!.name = nameTextFiield.text!
            shoppingToEditItem!.price = Float(priceField.text!)!
            shoppingToEditItem!.quantity = quantityField.text!
            shoppingToEditItem!.info = extraInfoField.text!
            
            shoppingToEditItem!.image = imageData
            
            shoppingToEditItem?.updateItemInBackground(shoppingItem: shoppingToEditItem!, completion: { (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "Error updating item")
                    return
                }
            })
            self.dismiss(animated:true, completion: nil)
            
        } else  if grocItem != nil {
            
            grocItem!.name = nameTextFiield.text!
            grocItem!.price = Float(priceField.text!)!
            grocItem!.info = extraInfoField.text!
            grocItem!.image = imageData
            
            grocItem?.updateItemInBackground(groceryItem: grocItem!, completion: { (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "Error updating grocery item")
                    return
                }
            })
            
            
        }
        
    }
    
    func saveItem() {
        
        var shoppingProd: ShoppingDetail
        
        var imageData: String!
        
        if itemImage != nil {
            let image = itemImage?.jpegData(compressionQuality: 0.5)
            imageData = image?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        }else {
            imageData = ""
        }
        
        if addingToList! {
            //add to products list only
            shoppingProd = ShoppingDetail(_name: nameTextFiield.text!, _info: extraInfoField.text!, _price: Float(priceField.text!)!, _shoppingListId: "")
            
            let productItem = GroceryItem(shoppingItem: shoppingProd)
            productItem.image = imageData
            
            productItem.saveItemInBackground(groceryItem: productItem) { (error) in
                if error != nil {
                    
                    SVProgressHUD.showError(withStatus: "Error Saving grocery item")
                    return
                }
            }
            
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            //save to current shopping list
            
            let shoppingItem = ShoppingDetail(_name: nameTextFiield.text!, _info: extraInfoField.text!, _quantity: quantityField.text!, _price: Float( priceField.text!)!, _shoppingListId: shoppingList.id)
            
            shoppingItem.image = imageData
            
            shoppingItem.saveItemsInBackground(shoppingItem: shoppingItem,  completion: { (error) in
                if error != nil {
                    
                    SVProgressHUD.showError(withStatus: "Error saving shopping item")
                    return
                }
            })
            
            showListNotification(shoppingItem: shoppingItem)
        }
    }
    
    func showListNotification(shoppingItem: ShoppingDetail) {
        
        let alertController = UIAlertController(title: "Shopping Items", message: "Do you want to add this item to your item?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            //save to grocery lis
            
            let groceryItem = GroceryItem(shoppingItem: shoppingItem)
            
            groceryItem.saveItemInBackground(groceryItem: groceryItem, completion: { (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "Error creating grocery item")
                }
            })
            
            self.dismiss(animated: true, completion: nil)
        
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerController delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.itemImage = (info[UIImagePickerController.InfoKey.editedImage]) as? UIImage
        
        self.imageView.image = itemImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Update item detail UI
    
    func updateItemDetail() {
        
        if shoppingToEditItem != nil {
            
            self.nameTextFiield.text = self.shoppingToEditItem!.name
            self.extraInfoField.text = self.shoppingToEditItem!.info
            self.quantityField.text = self.shoppingToEditItem!.quantity
            self.priceField.text = "\(self.shoppingToEditItem!.price)"
            
            if shoppingToEditItem!.image != ""{
                
                
                imageFromData(pictureData: shoppingToEditItem!.image) { (image) in
                     self.itemImage = image!
                     imageView.image = image!
                }
            }
            
            
        } else  if grocItem != nil {
            self.nameTextFiield.text = self.grocItem!.name
            self.extraInfoField.text = self.grocItem!.info
            self.quantityField.text = ""
            self.priceField.text = "\(self.grocItem!.price)"
            
            if grocItem!.image != ""{
                
                
                imageFromData(pictureData: grocItem!.image) { (image) in
                    self.itemImage = image!
                    imageView.image = image!
                }
            }
            
            
        }
    }
    
    
}



