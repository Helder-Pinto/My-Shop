//
//  ShoppingItemViewController.swift
//  MyShop
//
//  Created by Apple on 26/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import SwipeCellKit
import SVProgressHUD

class ShoppingItemViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate{
    
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = true
    
    var shoppingDetails: ShoppingList!
    
    var shoppingItems: [ShoppingDetail] = []
    var boughtItems: [ShoppingDetail] = []
    
    var totalPrice: Float!
    
    @IBOutlet weak var itemsLeftLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadShoppingItems()

       
    }
    
    
    //MARK: TableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return shoppingItems.count
        } else {
            return boughtItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShoppingItemViewCell
        
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        var item : ShoppingDetail!
        if indexPath.section == 0 {
            item = shoppingItems[indexPath.row]
            
        }else {
            item = boughtItems[indexPath.row]
        }
        
        cell.bindData(item: item)
        
        return cell
    }
    
    //MARK: TableViewDelegates
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title: String!
        
        if section == 0 {
            
            title = "Shopping List"
        }else {
            
            title = "Bought List"
        }
        
        return titleViewForTable(titleText: title)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view 
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
  
    
    
    
    //MARK: IBActions
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
        
        vc.shoppingList = self.shoppingDetails
        
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: Load ShoppingItems
    
    func loadShoppingItems() {
        
        firebase.child(kSHOPPINGITEM).child(shoppingDetails.id).queryOrdered(byChild: kSHOPPINGLISTID).queryEqual(toValue: shoppingDetails.id).observe(.value, with: {snapshot in
            self.shoppingItems.removeAll()
            self.boughtItems.removeAll()
            
            if snapshot.exists(){
                let allItems = (snapshot.value as! NSDictionary).allValues as Array
                
                for item in allItems {
                    
                    let currentItem = ShoppingDetail.init(dictionary: item as! NSDictionary)
                    
                    if currentItem.isBought {
                        self.boughtItems.append(currentItem)
                    } else {
                        self.shoppingItems.append(currentItem)
                    }
                }
            }else {
                print("no snapshot")
            }
            
            self.calculateTotal()
            self.updateUI()
        })
    }
    
    
    func updateUI() {
        self.itemsLeftLabel.text = "Items Left: \(self.shoppingItems.count)"
        self.totalPriceLabel.text = "Total Price: $ \(String(format:"%.2f", self.totalPrice!))"
        
        self.tableView.reloadData()
    }
    //MARK: SwipeTableViewCell delegate functions
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var item: ShoppingDetail!
        // If swipe left
        if indexPath.section == 0 {
            item = shoppingItems[indexPath.row]
        } else {
            item = boughtItems[indexPath.row]
        }
        if orientation == .left {
            guard isSwipeRightEnabled else {
                return nil
            }
            let buyItem = SwipeAction(style: .default, title: nil, handler: {action, indexPath in
                
                item.isBought = !item.isBought
                item.updateItemInBackground(shoppingItem: item, completion: { (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: "Error coudnt update item")
                        return
                    }
                })
                if indexPath.section == 0 {
                    
                    self.shoppingItems.remove(at: indexPath.row)
                    self.boughtItems.append(item)
                } else {
                    self.shoppingItems.append(item)
                    self.boughtItems.remove(at: indexPath.row)
                }
                tableView.reloadData()
            })
            buyItem.accessibilityLabel = item.isBought ? "Buy" : "Return"
            let descriptor: ActionDescriptor = item.isBought ? .returnPurchase : .buy
            
            configure(action: buyItem, with: descriptor)
            
            return [buyItem]
            //if swipe right
        } else {
            
            let delete = SwipeAction(style: .destructive, title: nil, handler: { (action, indexPath) in
                
                if indexPath.section == 0 {
                    self.shoppingItems.remove(at: indexPath.row)
                } else {
                    self.boughtItems.remove(at: indexPath.row)
                    
                }
                item.deleteItemInBackground(shoppingItem: item)
                
                
                
                self.tableView.beginUpdates()
                action.fulfill(with: .delete)
                self.tableView.endUpdates()
                
                })
            configure(action: delete, with: .trash)
            return [delete]
        }
        
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
    
    //MARK: Helper functions
    
    func calculateTotal () {
        
        self.totalPrice = 0
        for item in boughtItems {
            self.totalPrice = self.totalPrice + item.price
            
        }
        for item in shoppingItems {
            totalPrice = totalPrice + item.price
        }
        self.totalPriceLabel.text = "Total Price: \(String(format: "%.2f", self.totalPrice!))"
        
        shoppingDetails.totalPrice = self.totalPrice
        shoppingDetails.totalItems = self.boughtItems.count + self.shoppingItems.count
        
        shoppingDetails.updateItemInBackground(shoppingList: shoppingDetails) { (error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "Error updating shopping list")
                return
            }
        }
    }
    
    func titleViewForTable(titleText: String) -> UIView {
        
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 20))
        titleLabel.text = titleText
        titleLabel.textColor = .white
        
        view.addSubview(titleLabel)
        return view
    }
}
