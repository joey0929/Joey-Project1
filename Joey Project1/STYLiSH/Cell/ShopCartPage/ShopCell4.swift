//
//  ShopCell4.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/31.
//


protocol ShopCell4Delegate: AnyObject {
    func didselectnum(selectnum: Int)
}






import UIKit
import IQKeyboardManagerSwift



class ShopCell4: UITableViewCell ,UITextFieldDelegate {

    @IBOutlet weak var numberLabel: UILabel!
    
    
    @IBOutlet weak var stockLabel: UILabel!
    
    
    @IBOutlet weak var minusButton: UIButton!
    
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var seperateView: UIView!
    weak var delegate: ShopCell4Delegate? //用於監聽textField
    var stockNumber = 0
    var bagNumber = 0
    var maxNum = 0
    var minNum = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numberLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        stockLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
        seperateView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        let bcolor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        //UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        //let bcolor2 = UIColor.black.cgColor
        minusButton.layer.borderColor = bcolor.cgColor
        minusButton.layer.borderWidth = 1
        
        addButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        addButton.layer.borderWidth = 1
        
        numberTextField.text = "1"
        numberTextField.keyboardType = .numberPad
        numberTextField.delegate = self
        numberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .valueChanged) //用於觀察最後選了什麼數字

    }
    
    func updateNumChange() { //更新textField的改動
        let selectNum = Int(numberTextField.text ?? "0") ?? 0
        delegate?.didselectnum(selectnum: selectNum)
    }
    
    func getMaxNum(maxN: Int) {
        maxNum = maxN
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            let selectNum = Int(textField.text ?? "0") ?? 0
            delegate?.didselectnum(selectnum: selectNum) //把選中的資料delegate出去
        }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func getStockNumber(number: Int) {
        stockNumber = number
        stockLabel.text = "庫存: \(number)"  
        maxNum = stockNumber
    }
    
    func resetNumberStock() {
        numberTextField.text = "1"
        stockLabel.text = "庫存: " 
        addButton.isEnabled = true
        addButton.alpha = 1.0
        minusButton.isEnabled = false
        minusButton.alpha = 0.5
        
    }
    
    //MARK: - TextField Setting
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 獲取當前框中的內容
            let currentText = textField.text ?? ""
            // 根據輸入來更新框中的內容
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // 確認框中的內容是數字
            if let newValue = Int(updatedText) {
                // 檢查數字是否在maxNum 跟 minNum 的範圍內
                return newValue >= minNum && newValue <= maxNum
            }
            
            // 如果輸入的是非數字，則阻止輸入
            return updatedText.isEmpty
        }
    
    
    
    
    
    @IBAction func addNumber(_ sender: Any) {
        
        
            if let curNumber = Int(numberTextField.text ?? "0"), curNumber < maxNum {
                let newNumber = curNumber + 1
                numberTextField.text = "\(newNumber)"
                updateNumChange()
                // 當數字達到 maxNum 時，將加號按鈕的 alpha 設為 0.5 並禁用
                if newNumber == maxNum {
                    addButton.alpha = 0.5
                    addButton.isEnabled = false
                    minusButton.alpha = 1.0
                    minusButton.isEnabled = true
                } else {
                    // 確保按鈕在數字小於 maxNum 時啟用
                    addButton.alpha = 1.0
                    addButton.isEnabled = true
                }
                
                // 當數字大於0時，啟用減少按鈕並將邊框設置為黑色
                minusButton.isEnabled = true
                minusButton.layer.borderColor = UIColor.black.cgColor
            }
    }
    
    
    @IBAction func minusNumber(_ sender: Any) {
        
        if let curNumber = Int(numberTextField.text ?? "0"), curNumber > 1 {
                let newNumber = curNumber - 1
                numberTextField.text = "\(newNumber)"
                updateNumChange()
                // 當數字變成1時，將減少按鈕禁用，並將 alpha 設置為 0.5
                if newNumber == 1 {
                    minusButton.alpha = 0.5
                    minusButton.isEnabled = false
                    addButton.alpha = 1.0
                    addButton.isEnabled = true
                } else {
                    // 確保按鈕在數字大於1時啟用
                    minusButton.alpha = 1.0
                    minusButton.isEnabled = true
                }
                
                // 當數字小於 maxNum 時，將加號按鈕的 alpha 恢復到 1 並啟用
                if newNumber < maxNum {
                    addButton.alpha = 1.0
                    addButton.isEnabled = true
                }
            }
        
    }
    

    
    

}
