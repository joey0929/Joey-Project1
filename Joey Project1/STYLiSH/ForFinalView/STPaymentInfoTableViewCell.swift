//
//  STPaymentInfoTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/26.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import TPDirect


private enum PaymentMethod: String { //用於picker 的 case
    
    case creditCard = "信用卡付款"
    
    case cash = "貨到付款"
}

protocol STPaymentInfoTableViewCellDelegate: AnyObject {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell)
    
    func didChangeUserData(
        _ cell: STPaymentInfoTableViewCell,
        payment: String,
        cardNumber: String,
        dueDate: String,
        verifyCode: String
    )
    
    func checkout(_ cell:STPaymentInfoTableViewCell,withPrime prime:String)
    
    func readyToGetPrime(ready:Bool)
    
    func selectPay(flag:Int)
}

class STPaymentInfoTableViewCell: UITableViewCell {
    
    
    var tpdCard : TPDCard!
    var tpdForm : TPDForm!
    var flag = false
    var flag2 = 0   //用於付款方式 0 cash 1 貨到
    var ready = true
    
    @IBOutlet weak var paymentTextField: UITextField! {  //將原先有的三個輸入框先hidden掉
        
        didSet {
        
            let shipPicker = UIPickerView()
            
            shipPicker.dataSource = self
            
            shipPicker.delegate = self
            
            paymentTextField.inputView = shipPicker
            
            let button = UIButton(type: .custom)
            
            button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            
            button.setBackgroundImage(
                UIImage.asset(.Icons_24px_DropDown),
                for: .normal
            )
            
            button.isUserInteractionEnabled = false
            
            paymentTextField.rightView = button
            
            paymentTextField.rightViewMode = .always
            
            paymentTextField.delegate = self
            paymentTextField.keyboardType = .numberPad
            paymentTextField.text = PaymentMethod.cash.rawValue
        }
    }
    
    @IBOutlet weak var cardNumberTextField: UITextField! {
        
        didSet {
            cardNumberTextField.isHidden = true
            cardNumberTextField.delegate = self
            cardNumberTextField.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var dueDateTextField: UITextField! {
        
        didSet {
            dueDateTextField.isHidden = true
            dueDateTextField.delegate = self
            dueDateTextField.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var verifyCodeTextField: UITextField! {
        
        didSet {
            verifyCodeTextField.isHidden = true
            verifyCodeTextField.delegate = self
        }
    }
    
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var shipPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productAmountLabel: UILabel!
    @IBOutlet weak var topDistanceConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkoutButton: UIButton!  //確認按鈕
    @IBOutlet weak var creditView: UIView! {
        
        didSet {  //數值有更動就會呼叫
        
            creditView.isHidden = true
            setupCreditCardInput()
            
        }
    }
    
    private let paymentMethod: [PaymentMethod] = [.cash, .creditCard]
    weak var delegate: STPaymentInfoTableViewCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func layoutCellWith(
        productPrice: Int,
        shipPrice: Int,
        productCount: Int
    ) {
        
        productPriceLabel.text = "NT$ \(productPrice)"
        
        shipPriceLabel.text = "NT$ \(shipPrice)"
        
        totalPriceLabel.text = "NT$ \(shipPrice + productPrice)"
        
        productAmountLabel.text = "總計 (\(productCount)樣商品)"
    }
    
    @IBAction func checkout() { //按下確認按鈕後 去拿到getPrime
        tpdCard.getPrime()
    }
    
    func setupCreditCardInput() {  //Card setting
            tpdForm = TPDForm.setup(withContainer: creditView)
            tpdForm.onFormUpdated { (status) in
                if status.isCanGetPrime() { //確認是否可以get prime 跟前面cell的輸入狀態用flag表示
                    // Enable the checkout button if the form is valid
                    self.delegate?.readyToGetPrime(ready: self.ready)
                } else {
                    // Disable the checkout button if the form is invalid
                }
            }
            tpdCard = TPDCard.setup(tpdForm)
            tpdCard.onSuccessCallback { (prime, cardInfo, cardIdentifier, merchantReferenceInfo) in
                guard let prime = prime else{
                    return
                }
                self.delegate?.checkout(self, withPrime: prime)
            }.onFailureCallback { (status, message) in
                print("Failure: \(message)")
            }
        }
    
    
}


//MARK: - Picker Setting
extension STPaymentInfoTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int
    {
        return 2
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String?
    {
        
        return paymentMethod[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        paymentTextField.text = paymentMethod[row].rawValue
    }
    
    private func manipulateHeight(_ distance: CGFloat) {
        
        topDistanceConstraint.constant = distance
        
        delegate?.didChangePaymentMethod(self)
    }
}


extension STPaymentInfoTableViewCell: STOrderUserInputCellDelegate {
    func didChangeUserData(_ cell: STOrderUserInputCell, username: String, email: String, phoneNumber: String, address: String, shipTime: String) {
        
    }
    
    func notifyToEnableButton(isNotEmpty: Bool) {

    }
    
}

//MARK: - TextField  Setting
extension STPaymentInfoTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField != paymentTextField {
            
            passData()
            
            return
        }
        
        guard
            let text = textField.text,
            let payment = PaymentMethod(rawValue: text) else
        {
            
            passData()
            
            return
        }
        
        switch payment {
            
        case .cash:
            flag2 = 0
            delegate?.selectPay(flag: flag2)
            delegate?.readyToGetPrime(ready: false)
            manipulateHeight(44)
            creditView.isHidden = true
            
            
        case .creditCard:
            flag2 = 1
            delegate?.selectPay(flag: flag2)
            delegate?.readyToGetPrime(ready: false)
            manipulateHeight(228)
            
            creditView.isHidden = false
        }
        
        passData()
    }
    
    private func passData() {
        
        guard
            let cardNumber = cardNumberTextField.text,
            let dueDate = dueDateTextField.text,
            let verifyCode = verifyCodeTextField.text,
            let paymentMethod = paymentTextField.text else
        {
            return
        }
        
        delegate?.didChangeUserData(
            self,
            payment: paymentMethod,
            cardNumber: cardNumber,
            dueDate: dueDate,
            verifyCode: verifyCode
        )
    }
}
