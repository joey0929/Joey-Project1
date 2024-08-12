//
//  ShopCell2.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/31.
//

import UIKit


protocol ShopCell2Delegate: AnyObject {
    func didSelctColor(colorCode: String)
}




class ShopCell2: UITableViewCell {

    
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorButton1: UIButton!
    @IBOutlet weak var colorButton2: UIButton!
    @IBOutlet weak var colorButton3: UIButton!
    @IBOutlet weak var colorButton4: UIButton!
    @IBOutlet weak var colorButton5: UIButton!
    
    var colorsArray : [String] = []
    
    weak var delegate: ShopCell2Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    func getData(colors: [String]) {
        colorsArray = colors
    }
    
    
    func resetBorder() {
        
        colorButton1.layer.borderWidth = 0
        colorButton2.layer.borderWidth = 0
        colorButton3.layer.borderWidth = 0
    }
    
    
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender == colorButton1 {
            colorButton1.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            colorButton1.layer.borderWidth = 2
            colorButton2.layer.borderWidth = 0
            colorButton3.layer.borderWidth = 0
            delegate?.didSelctColor(colorCode: colorsArray[0])
            
        } else if sender == colorButton2 {
            colorButton2.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            colorButton2.layer.borderWidth = 2
            colorButton1.layer.borderWidth = 0
            colorButton3.layer.borderWidth = 0
            delegate?.didSelctColor(colorCode: colorsArray[1])
            
        } else if sender == colorButton3 {
            colorButton3.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            colorButton3.layer.borderWidth = 2
            colorButton1.layer.borderWidth = 0
            colorButton2.layer.borderWidth = 0
            delegate?.didSelctColor(colorCode: colorsArray[2])
        }
    }
    
    
    func configureColor(colors: [String]) {
        let cCount = colors.count
        for i in 0..<cCount {
            if (i == 0) {
                colorButton1.backgroundColor = UIColor(hex: colors[i])
            } else if i == 1 {
                colorButton2.backgroundColor = UIColor(hex: colors[i])
            } else {
                colorButton3.backgroundColor = UIColor(hex: colors[i])
            }
            
            
        }
        
        
        
    }
    
    
    

}

