import UIKit
import Kingfisher
import IQKeyboardManagerSwift



class ViewController2: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let header = ["結帳商品", "收件資訊", "付款詳情"]
    var cartItems2: [ShopCartData] = [] //用於接下CoreData的資料
    var totalPrice = 0
    var cell4Button : UIButton? //去接cell的button
    var isUserInputComplete = false  //用於確認使用者資訊誆輸是否都有輸入
    var isGetPrimeReady = false  //用於確認信用卡付款資訊是否輸入正確
    var whichPayment: Int = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        tableView.lk_registerCellWithNib(identifier: String(describing: STOrderProductCell.self), bundle: nil)
        
        tableView.lk_registerCellWithNib(identifier: String(describing: STOrderUserInputCell.self), bundle: nil)
        
        tableView.lk_registerCellWithNib(identifier: String(describing: STPaymentInfoTableViewCell.self), bundle: nil)
        
        let headerXib = UINib(nibName: String(describing: STOrderHeaderView.self), bundle: nil)
        
        tableView.register(headerXib, forHeaderFooterViewReuseIdentifier: String(describing: STOrderHeaderView.self))
        
        
        //更新返回的圖示
        self.navigationController?.navigationBar.topItem?.title = "" // 去除back字樣
        let backButtonImage = UIImage(named: "Icons_44px_Back02")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
        
        for item in cartItems2 {
            totalPrice += Int(item.price * item.select) //計算總價
        }
       
        
    }
    
   
    
    
}




// MARK: - TableView Setting
extension ViewController2: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: STOrderHeaderView.self)) as? STOrderHeaderView else {
            return nil
        }
        
        headerView.titleLabel.text = header[section]
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        guard let footerView = view as? UITableViewHeaderFooterView else { return }
        
        footerView.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "cccccc")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return header.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cartItems2.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productDetail = cartItems2[indexPath.row]
        
        var cell: UITableViewCell
        
        if indexPath.section == 0 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STOrderProductCell.self), for: indexPath) as! STOrderProductCell
            (cell as! STOrderProductCell).configure(product: productDetail)  //這邊去做 將得到的product資訊 放到cell 上
            
            
        } else if indexPath.section == 1 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STOrderUserInputCell.self), for: indexPath)
            
            guard let userInfoCell = cell as? STOrderUserInputCell else {
                
                return cell
            }
            
            userInfoCell.delegate = self
            //Todo
            
            /*
                請適當的安排 STOrderUserInputCell，讓 ViewController 可以收到使用者的輸入
             */
            
        } else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STPaymentInfoTableViewCell.self), for: indexPath)

            guard let paymentCell = cell as? STPaymentInfoTableViewCell else {
                
                return cell
            }
            paymentCell.productPriceLabel.text = String(totalPrice)
            paymentCell.totalPriceLabel.text = String(totalPrice + 60)
            paymentCell.productAmountLabel.text = String("總計 (\(cartItems2.count)樣商品)")
            self.cell4Button = paymentCell.checkoutButton
            paymentCell.delegate = self
            
        }
        
        return cell
    }
}



extension ViewController2: STOrderUserInputCellDelegate {
    func notifyToEnableButton(isNotEmpty: Bool) {
        self.isUserInputComplete = isNotEmpty
        checkStatus()
        print("isuserinput Ready")
    }
    
    func didChangeUserData(_ cell: STOrderUserInputCell, username: String, email: String, phoneNumber: String, address: String, shipTime: String) {
        
    }
}

extension ViewController2: STPaymentInfoTableViewCellDelegate {
    func selectPay(flag: Int) {
        self.whichPayment = flag
    }

    
    func readyToGetPrime(ready: Bool) {
        self.isGetPrimeReady = ready
        checkStatus()
        print("ready: \(ready), isgetprimeready \(isGetPrimeReady)")
        print("ispirme ready")
    }
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell) {
        
        tableView.reloadData()
    }
    
    func didChangeUserData(
        _ cell: STPaymentInfoTableViewCell,
        payment: String,
        cardNumber: String,
        dueDate: String,
        verifyCode: String
    ) {
        print(payment, cardNumber, dueDate, verifyCode)
    }

    func checkStatus() { //確認目前輸入狀態去改變按鈕外觀
        DispatchQueue.main.async {
            if (self.isGetPrimeReady == true && self.isUserInputComplete == true && self.whichPayment == 1) {
                self.cell4Button?.alpha = 1.0
                self.cell4Button?.backgroundColor = UIColor.black
                self.cell4Button?.isEnabled = true
            } else if (self.isUserInputComplete == true && self.whichPayment == 0){
                self.cell4Button?.alpha = 1.0
                self.cell4Button?.backgroundColor = UIColor.black
                self.cell4Button?.isEnabled = true
            } else {
                self.cell4Button?.alpha = 0.5
                self.cell4Button?.backgroundColor = UIColor.gray
                self.cell4Button?.isEnabled = false
            }
        }
    }
    
    
    
    func checkout(_ cell:STPaymentInfoTableViewCell,withPrime prime: String) {
        print("=============")
        print("User did tap checkout button")
        print("print \(prime)")
    }
}
