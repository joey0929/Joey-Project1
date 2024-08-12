//
//  ShopCell3.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/31.
//

import UIKit


protocol ShopCell3Delegate: AnyObject{
    func didSelctSize(size: String)
}



class ShopCell3: UITableViewCell {

    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var sizeButton1: UIButton!
    @IBOutlet weak var sizeButton2: UIButton!
    @IBOutlet weak var sizeButton3: UIButton!
    
    
    
    var sizeArray : [String] = []
    weak var delegate: ShopCell3Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sizeLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        sizeButton1.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        sizeButton2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        sizeButton3.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        sizeButton1.tintColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        sizeButton2.tintColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        sizeButton3.tintColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getData(sizes: [String]) {
        sizeArray = sizes
    }
    
    func resetBorder() {
        sizeButton1.layer.borderWidth = 0
        sizeButton2.layer.borderWidth = 0
        sizeButton3.layer.borderWidth = 0
    }
    
    
//    func clearSelectedSize() {
//        let buttons = [sizeButton1,sizeButton2,sizeButton3]
//        buttons.forEach { button in
//            button.layer.borderWidth = 0
//        }
//    }
    
    
    
    // 找出將庫存為0 的按鈕 disable掉 並更新button ui
    func updateSizeButton(stock : [String: Int]) {
        let buttons = [sizeButton1,sizeButton2,sizeButton3]
        
        for (index, size) in sizeArray.enumerated() {
            if let stocks = stock[size] ,stocks > 0 {
                buttons[index]?.isEnabled = true
                
            } else {
                buttons[index]?.isEnabled = false
                buttons[index]?.tintColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
                buttons[index]?.layer.borderWidth = 0

            }
            
        }
        
    }
    
    
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender == sizeButton1 {
            sizeButton1.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            sizeButton1.layer.borderWidth = 1
            sizeButton2.layer.borderWidth = 0
            sizeButton3.layer.borderWidth = 0
            delegate?.didSelctSize(size: sizeArray[0])
            
        } else if sender == sizeButton2 {
            sizeButton2.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            sizeButton2.layer.borderWidth = 1
            sizeButton1.layer.borderWidth = 0
            sizeButton3.layer.borderWidth = 0
            delegate?.didSelctSize(size: sizeArray[1])
        } else if sender == sizeButton3 {
            sizeButton3.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            sizeButton3.layer.borderWidth = 1
            sizeButton1.layer.borderWidth = 0
            sizeButton2.layer.borderWidth = 0
            delegate?.didSelctSize(size: sizeArray[2])
        }
    }
     
    
    func configureSize(sizes: [String]) {
        let sCount = sizes.count
        for i in 0..<sCount {
            if (i == 0) {
                sizeButton1.setTitle(sizes[i], for: .normal)
            } else if  i == 1 {
                sizeButton2.setTitle(sizes[i], for: .normal)
            } else  {
                sizeButton3.setTitle(sizes[i], for: .normal)
            }
            
        }
    }
    
    

}
