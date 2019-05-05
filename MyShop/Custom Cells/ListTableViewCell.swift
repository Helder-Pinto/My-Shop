//
//  ListTableViewCell.swift
//  MyShop
//
//  Created by Apple on 26/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func bindData(item: ShoppingList) {
        
        let currency = "$"
        //userDefaults.value(forKey: kCURRENCY) as! String
        
        let currentDateFormatter = dateFormatter()
        currentDateFormatter.dateFormat = "dd/MM/YYYY"
        
        let date = currentDateFormatter.string(from: item.date)
        
        self.nameLabel.text = item.name
        self.itemsLabel.text = "\(item.totalItems) items"
        self.totalLabel.text = "Total \(currency) \(String(format: "%.2f", item.totalPrice))"
        self.dateLabel.text = date
        
        self.nameLabel.sizeToFit()
        self.totalLabel.sizeToFit()
    }
    
}
