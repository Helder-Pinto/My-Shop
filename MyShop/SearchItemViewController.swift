//
//  SearchItemViewController.swift
//  MyShop
//
//  Created by Apple on 27/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import SwipeCellKit

class SearchItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {

    var groceryItems: [GroceryItem] = []
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = false
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroceryItems()

    }
    
    //MARK: Tableview datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productsCell", for: indexPath) as! ProductsCell
        
        
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        let productItem = groceryItems[indexPath.row]
        cell.bindData(item: productItem)
        
        
        return cell
    }
    
    //MARK: UIActions
    
    @IBAction func addbtnPressed(_ sender: Any) {
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
        
        vc.addingToList = true
        
        
        self.present(vc, animated: true, completion: nil)
        
    }
    //MARK: Load grocery items
    
    func loadGroceryItems() {
    
        firebase.child(kGROCERYITEM).child("1234").observe(.value, with: {
            snapshot in
            
            self.groceryItems.removeAll()
            
            if snapshot.exists(){
                
                let allItems = (snapshot.value as! NSDictionary).allValues as Array
                
                for item in allItems {
                    
                    let currentItem = GroceryItem(dictionary: item as! NSDictionary)
                    
                    self.groceryItems.append(currentItem)
                }
            } else {
                print("no snapshot")
            }
            self.tableView.reloadData()
        })
    }
    
    
    //MARK: Swipe
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
      
        // If swipe left
     
        if orientation == .left {
            guard isSwipeRightEnabled else {
                return nil
            }
        }
            
            let delete = SwipeAction(style: .destructive, title: nil, handler: { (action, indexPath) in
                
                var item: GroceryItem
                item = self.groceryItems[indexPath.row]
                
                self.groceryItems.remove(at: indexPath.row)
                
                item.deleteItemInBackground(groceryItem: item)
                
                self.tableView.beginUpdates()
                action.fulfill(with: .delete)
                self.tableView.endUpdates()
                
            })
            configure(action: delete, with: .trash)
            return [delete]
        }

        func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
            
            action.title = descriptor.title()
            action.image = descriptor.image()
            action.backgroundColor = descriptor.color
        }

        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeTableOptions()
            options.expansionStyle = orientation == .left ? .selection : .destructive
            options.transitionStyle = defaultOptions.transitionStyle
            options.buttonSpacing = 11
            
            return options
        
        

    }
}
