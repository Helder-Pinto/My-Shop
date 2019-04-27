//
//  ShoppingItemViewCell.swift
//  MyShop
//
//  Created by Apple on 26/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import SwipeCellKit

class ShoppingItemViewCell: SwipeTableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var extraINfo: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bindData(item: ShoppingDetail) {
        
        self.nameLabel.text = item.name
        self.extraINfo.text = item.info
        self.quantityLabel.text = item.quantity
        self.priceLabel.text = "$ \(item.price)"
        
        
        self.priceLabel.sizeToFit()
        self.nameLabel.sizeToFit()
        self.extraINfo.sizeToFit()
        
        //add image
    }

}
