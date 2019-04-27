//
//  ProductsCell.swift
//  MyShop
//
//  Created by Apple on 27/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit

class ProductsCell: ShoppingItemViewCell{

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.quantityBackView.isHidden = true
        self.quantityLabel.isHidden = true
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func bindData(item: ProductsItem) {
        
    }

}
