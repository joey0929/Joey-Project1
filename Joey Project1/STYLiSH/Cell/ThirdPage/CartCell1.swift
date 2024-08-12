//
//  CartCell1.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/8/4.
//

protocol CustomCellDelegate: AnyObject {
    func didTapDeleteButton(at indexPath: IndexPath)
    
    func didChangeNum(change:Int,at indexPath: IndexPath)
    
    func didupdateBadge() //用於按鈕更新badge數量
}




import UIKit

class CartCell1: UITableViewCell {

    
    
    @IBOutlet weak var imageview1: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var seperateView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textField1: UITextField!
    
    
    var maxNum = 0
    var minNum = 1
    
    weak var delegate: CustomCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField1.delegate = self
        textField1.text = "1"
        
        seperateView.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        let bcolor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        //UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        //let bcolor2 = UIColor.black.cgColor
        minusButton.layer.borderColor = bcolor.cgColor
        minusButton.layer.borderWidth = 1
        
        addButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        addButton.layer.borderWidth = 1
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    
//MARK: - Cell Remove
    @IBAction func removeCell(_ sender: Any) {
        
        if let indexPath = indexPath {
                    delegate?.didTapDeleteButton(at: indexPath)
                }
                
 
    }
    
    
    
    
    
    
    
//MARK: - Button Function
    @IBAction func addOne(_ sender: Any) {
        if let curNumber = Int(textField1.text ?? "0"), curNumber < maxNum {
            let newNumber = curNumber + 1
            textField1.text = "\(newNumber)"
            updateButtonStates(for: newNumber)
            
            if let indexPath = indexPath {
                delegate?.didChangeNum(change: newNumber, at: indexPath)
            }
            
            delegate?.didupdateBadge() //通知badge 更新數量
        }

        
    }
    
    @IBAction func minusOne(_ sender: Any) {
        if let curNumber = Int(textField1.text ?? "0"), curNumber > minNum {
            let newNumber = curNumber - 1
            textField1.text = "\(newNumber)"
            updateButtonStates(for: newNumber)
            
            if let indexPath = indexPath {
                delegate?.didChangeNum(change: newNumber, at: indexPath)
            }
            
            delegate?.didupdateBadge()
        }
        
    }
    
    func updateButtonStates(for number: Int) { //更新按鈕外觀
        addButton.isEnabled = number < maxNum
        addButton.alpha = addButton.isEnabled ? 1.0 : 0.5
        addButton.layer.borderColor = addButton.isEnabled ? UIColor.black.cgColor : UIColor.gray.cgColor
        
        minusButton.isEnabled = number > minNum
        minusButton.alpha = minusButton.isEnabled ? 1.0 : 0.5
        minusButton.layer.borderColor = minusButton.isEnabled ? UIColor.black.cgColor : UIColor.gray.cgColor
    }
    
    
    
    
}


//MARK: - Delegate Setting
extension CartCell1: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    
}
