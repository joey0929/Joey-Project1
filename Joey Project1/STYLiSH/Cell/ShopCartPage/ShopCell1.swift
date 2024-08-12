//
//  ShopCell1.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/30.
//



//用於關閉addtoCart的頁面
protocol ShopCell1Delegate: AnyObject {
    func closeShoppingView()
    func resetOtherCellsSelection()
}


import UIKit

class ShopCell1: UITableViewCell {
    
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var returnButton: UIButton!
    
    @IBOutlet weak var seperateView: UIView!
    
    weak var delegate: ShopCell1Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productName.textColor = UIColor(red: 63/255, green: 63/255, blue: 58/255, alpha: 1)
        priceLabel.textColor = UIColor(red: 63/255, green: 63/255, blue: 58/255, alpha: 1)
        seperateView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func backToDetail(_ sender: Any) {
        delegate?.closeShoppingView()  
        delegate?.resetOtherCellsSelection()
    }
    

}
