//
//  STOrderProductCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/25.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class STOrderProductCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var productSizeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(product: ShopCartData) {
        
        if let imageUrlString = product.image,
           let imageUrl = URL(string: imageUrlString) {
            productImageView.kf.setImage(with: imageUrl)
        } else {
            // 處理imageURL為nil或URL轉換失敗的情況
            print("URL error")
        }
        productTitleLabel.text = product.name
        productSizeLabel.text = product.size
        colorView.backgroundColor = UIColor(hex: product.color ?? "")
        priceLabel.text = String(product.price * product.select)
        orderNumberLabel.text = String(product.select)
        
        
    }
    
    
}
