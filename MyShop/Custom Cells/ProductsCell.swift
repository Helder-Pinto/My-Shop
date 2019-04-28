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
    
    func bindData(item: GroceryItem) {
         let currency = userDefaults.value(forKey: kCURRENCY) as! String
        self.nameLabel.text = item.name
        self.extraINfo.text = item.info
        self.priceLabel.text = "\(currency) \(String(format: "%.2f", item.price))"
        
        if item.image != "" {
            
            imageFromData(pictureData: item.image) { (image) in
                self.itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
                
            }
            
        } else {
            let image = UIImage(named: "ShoppingCartEmpty")
            
            self.itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
            
        }
        
    }

}
