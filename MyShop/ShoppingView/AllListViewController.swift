//
//  AllListViewController.swift
//  MyShop
//
//  Created by Apple on 26/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import SVProgressHUD
import ChameleonFramework

class AllListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var allLists: [ShoppingList] = []
    var nameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLists()
        tableView.separatorStyle = .none


    }
    
    //MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLists.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        
        let shoppingList = allLists[indexPath.row]
        
        
        cell.bindData(item: shoppingList)
        
        cell.backgroundColor = UIColor.randomFlat()
        
        return cell
        
    }
    
    //MArk: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "segueToItems", sender: indexPath)
    }
    
    //MARK: IBActions

    @IBAction func addButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Create Shopping List", message: "Enter the shoppinglist name", preferredStyle: .alert)
        
        alertController.addTextField { (nameTextField) in
            
            nameTextField.placeholder = "Name"
            self.nameTextField = nameTextField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if self.nameTextField.text != "" {
                
                self.createShoppingList()
                
            } else {
                SVProgressHUD.showError(withStatus: "Name is empty")
            }
          
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: LoadList
    
    func loadLists() {
        
        firebase.child(kSHOPPINGLIST).child("1234").observe(.value, with:{
         snapshot in
            
            self.allLists.removeAll()
            if snapshot.exists() {
                
                let sorted = (( snapshot.value as! NSDictionary).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)])
                
                for list in sorted {
                    
                    let currentList = list as! NSDictionary
                    self.allLists.append(ShoppingList.init(dictionary: currentList))
                }
                
            } else {
                print("no snapshot")
            }
            
            self.tableView.reloadData()
        })
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToItems" {
            let indexPath = sender as! IndexPath
            let shoppingList = allLists[indexPath.row]
            let vc = segue.destination as! ShoppingItemViewController
            
            vc.shoppingDetails = shoppingList
            
        }
    }
    
    //MARKER: Helper functions
    
    func createShoppingList() {
        
        let shoppingList = ShoppingList(_name: nameTextField.text!)
        shoppingList.saveItemsInBackground(shoppingList: shoppingList) { (error) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: "Error creating shopping list")
                return
            }
        }
    }
    
}
