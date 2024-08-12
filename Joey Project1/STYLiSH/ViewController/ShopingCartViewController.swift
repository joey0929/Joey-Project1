//
//  ShopingCartViewController.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/30.
//

import UIKit

import CoreData

protocol ShoppingCartViewDelegate : AnyObject {
    func didUpdateAddToCart()
    
    func disableToCart() 
    
    func resetColorSize()
    
    func passSelectColorSize(color:String,size:String,stock:Int)
    
    func passSelectNum(num:Int)
    
}



class ShopingCartViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var commonProduct: CommonProduct?
    
    weak var delegate: ShopCell1Delegate?
    weak var delegate2: ShopCell2Delegate?
    weak var delegate3: ShopCell3Delegate?
    weak var delegate4: ShoppingCartViewDelegate?
    weak var delegate5: ShopCell4Delegate?
    
    var selectedColor: String?
    var selectedSize: String?
    var stock: Int = 0
    var colorSizeGroups =  [String: [String: Int]]()
    var selectedNum: Int = 0 //選擇到的數字
    var selectCount = 0
    
    //reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if let variants = commonProduct?.variants { // 使用 commonProduct 的属性進行轉換
            for variant in variants {
                if colorSizeGroups[variant.colorCode] == nil {
                    colorSizeGroups[variant.colorCode] = [String: Int]()
                }
                colorSizeGroups[variant.colorCode]?[variant.size] = variant.stock
            }
        }
        
    }
    
    
    func completeSelection() {
        if let color = selectedColor, let size = selectedSize {
            delegate4?.passSelectColorSize(color: color, size: size,stock: stock)
        }
    }
    
    
    
    //更新庫存
    func updateStockLabel() {
        guard let selectedColor = selectedColor, let selectedSize = selectedSize else {
            resetColorSize()
            let cell4 = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? ShopCell4
            cell4?.numberTextField.isEnabled = false
            cell4?.addButton.isEnabled = false
            cell4?.minusButton.isEnabled = false
            return
        }
        

        if let stock = colorSizeGroups[selectedColor]?[selectedSize] {
            self.stock = stock  //庫存存到 全域變數stock
            if let cell4 = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? ShopCell4 {
                cell4.resetNumberStock()
                cell4.getStockNumber(number: stock)
                self.delegate4?.didUpdateAddToCart()
            }

            if stock > 0 {
                let cell4 = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? ShopCell4
                cell4?.numberTextField.isEnabled = true
                self.delegate4?.didUpdateAddToCart()
                
            } else {
                let cell4 = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? ShopCell4
                cell4?.numberTextField.isEnabled = false
                self.delegate4?.disableToCart()
            }
        } else {
            let cell4 = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? ShopCell4
            cell4?.numberTextField.isEnabled = false
            cell4?.addButton.isEnabled = false
            cell4?.minusButton.isEnabled = false
            delegate4?.disableToCart()
        }
    }

    
    
    func resetColorSize() {
        // 重置顏色
        resetColorSelection()
        // 重置尺寸
        resetSizeSelection()
        selectedSize = nil
        selectedColor = nil
        let cell4 = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? ShopCell4
        cell4?.stockLabel.text = "庫存 "
    }
    
    
    func resetColorSelection() {
        let cell2 = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ShopCell2
        cell2?.resetBorder()
        selectedColor = ""
    }
    
    func resetSizeSelection() {
        
        let cell3 = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ShopCell3
        cell3?.resetBorder()
        selectedSize = ""
    }
        
    
}

// MARK: - TableView Setting
extension ShopingCartViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ShopCell1
            cell.delegate = self
            cell.productName.text = commonProduct?.title
            
            if let p = commonProduct?.price {
                cell.priceLabel.text = "NT$" + String(p)
            }
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ShopCell2
            
            if let colors = commonProduct?.colors.map({ $0.code }) {
                cell.getData(colors: colors)
                cell.delegate = self
                cell.configureColor(colors: colors)
            }
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! ShopCell3
            
            if let sizes = commonProduct?.sizes {
                cell.getData(sizes: sizes)
                cell.delegate = self
                cell.configureSize(sizes: sizes)
            }
            
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! ShopCell4
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
}


// MARK: - ShopCell1 Delegate Setting
extension ShopingCartViewController: ShopCell1Delegate {
    func resetOtherCellsSelection() {
        if let colorCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ShopCell2{
            colorCell.resetBorder()
        }
        
        // 重置尺寸选择 cell
        if let sizeCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ShopCell3 {
            sizeCell.resetBorder()
            
        }
    }
    
    func closeShoppingView() {
        delegate?.closeShoppingView()
    }
}

// MARK: - ShopCell2 Delegate Setting
extension ShopingCartViewController: ShopCell2Delegate {
    
    func didSelctColor(colorCode: String) {
      
        self.selectedColor = colorCode
        resetSizeSelection()
        
        if let sizestock = self.colorSizeGroups[self.selectedColor ?? ""] { //點擊按鈕拿到資料後 去讀取size庫存
            
            if let cell3 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ShopCell3 {
                cell3.updateSizeButton(stock: sizestock) 
                delegate4?.disableToCart()
            }
        }
        
        if let cell4 = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? ShopCell4 {
            cell4.resetNumberStock() //重製textfield
        }
        
        // 在這裡更新UI，更新第四個cell的庫存數量顯示
        self.updateStockLabel()
      
    }
    
    
}

// MARK: - ShopCell3 Delegate Setting
extension ShopingCartViewController: ShopCell3Delegate {
    func didSelctSize(size: String) {

        self.selectedSize = size
        if let cell4 = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? ShopCell4 {
            cell4.resetNumberStock()
        }
  
         //在這裡更新UI，例如更新第四個cell的庫存數量顯示
        if let selectedColor = selectedColor, let selectedSize = selectedSize {
            self.updateStockLabel()
            
            delegate4?.passSelectColorSize(color: selectedColor, size: selectedSize,stock: stock) //將選中的顏色與資料傳到detailpage
            
        } else {
            let cell4 = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! ShopCell4
            cell4.stockLabel.text = "庫存: "
        }
        
    }
    
}


extension ShopingCartViewController: ShopCell4Delegate {
    func didselectnum(selectnum: Int) {
        self.selectedNum = selectnum //將textField選的數值傳入
        delegate4?.passSelectNum(num: selectnum)
    }
}
