//
//  ShoppingItemViewController.swift
//  MyShop
//
//  Created by Apple on 26/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit

class ShoppingItemViewController: UIViewController {
    
    var shoppingDetails: ShoppingList!
    
    @IBOutlet weak var itemsLeftLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    //MARK: IBActions
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
        
        vc.shoppingList = self.shoppingDetails
        
        self.present(vc, animated: true, completion: nil)
    }
    
}
