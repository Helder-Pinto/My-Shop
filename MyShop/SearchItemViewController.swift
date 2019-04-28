//
//  SearchItemViewController.swift
//  MyShop
//
//  Created by Apple on 27/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol SearchItemViewControllerdelegate {
    func didChooseItem(groceryItem: GroceryItem)
}

class SearchItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, UISearchResultsUpdating {
    
    
    var groceryItems: [GroceryItem] = []
    var filteredGroceryItems: [GroceryItem] = []
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = false
    var clickToEdit = true
    
    var delegate: SearchItemViewControllerdelegate?
   
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.tableView.setContentOffset((CGPoint(x: 0.0, y: 44.0)), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBtn.isHidden = clickToEdit
        addButton.isHidden = !clickToEdit
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        loadGroceryItems()
        

    }
    
    //MARK: Tableview datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredGroceryItems.count
        }
        return groceryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productsCell", for: indexPath) as! ProductsCell
        
        
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        var item:GroceryItem
        
        if searchController.isActive && searchController.searchBar.text != "" {
           
            item = filteredGroceryItems[indexPath.row]
        } else {
             item =  groceryItems[indexPath.row]
        }
        

        cell.bindData(item: item)
        
        
        return cell
    }
    
    //MARK: TableView Delegate functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var item:GroceryItem
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            item = filteredGroceryItems[indexPath.row]
        } else {
            item =  groceryItems[indexPath.row]
        }
        
        
        if !clickToEdit {
            
            self.delegate!.didChooseItem(groceryItem: item)
            
            
            self.dismiss(animated: true, completion: nil)
        } else {
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
            
            vc.grocItem = item
            
            self.present(vc, animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    
    //MARK: UIActions
    
    @IBAction func addbtnPressed(_ sender: Any) {
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
        
        vc.addingToList = true
        
        
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
                
                if self.searchController.isActive && self.searchController.searchBar.text != "" {
                    
                     item = self.filteredGroceryItems[indexPath.row]
                        self.filteredGroceryItems.remove(at: indexPath.row)
                    
                } else {
                    
                    
                    item = self.groceryItems[indexPath.row]
                    
                    self.groceryItems.remove(at: indexPath.row)
                    
                }
              
                
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
    
    //MARK: SearchController
    
    func filterContentForSearchText(searchText: String, Scope: String = "All") {
        
        filteredGroceryItems = groceryItems.filter({ (item) -> Bool in
            
            return item.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
