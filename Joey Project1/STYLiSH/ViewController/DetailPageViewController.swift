//
//  DetailPageViewController.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/26.
//

import UIKit
import StatusAlert
import CoreData



// 定義轉換的struct
struct CommonProduct {
    let id: Int
    let category: String
    let title: String
    let description: String
    let price: Int
    let texture: String
    let wash: String
    let place: String
    let note: String
    let story: String
    let mainImage: String
    let images: [String]
    let variants: [CommonVariant]
    let colors: [CommonColor]
    let sizes: [String]
}

struct CommonVariant {
    let colorCode: String
    let size: String
    let stock: Int
}

struct CommonColor {
    let code: String
    let name: String
}







class DetailPageViewController: UIViewController {

    
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var shopingView: UIView!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var seperateLine: UIView!
    
    var receiveData: CamelCase.Product?  //用於接收first page頁面來的資料
    var receiveProduct : Productlist2.Datum?   //用於接收second page頁面來的資料
    var commonProduct: CommonProduct? //用於轉換成一樣形態的struct
    var colorSizeGroups =  [String: [String: Int]]()  //用於計算 stock
    var parentTabBarController: UITabBarController? //控制tabBar的顯示
    
    var flag = 0  // 讓加入購物車按鈕分辨要執行哪種
  

    
    var selectedColor: String?
    var selectedSize: String?
    var selectNum: Int = 1
    var badegeNum = 0 //用於badge顯示
    var selectedStock : Int?
    
    weak var shoppingCartView: ShopingCartViewController? //用於取用shopingcartView
    weak var shopDelegate : ShoppingCartViewDelegate?
    weak var shopCell4Delegate: ShopCell4?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "" //去除back 字樣
    }
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        parentTabBarController?.tabBar.isUserInteractionEnabled = false //進入這頁面先將tabBar部分先隱藏掉
             
        if let product = receiveData {
            commonProduct = convertToCommonProduct(from: product)  //來自homepage
        } else if let datum = receiveProduct {
            commonProduct = convertToCommonProduct(from: datum) //來自second view
        }
        
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.estimatedRowHeight = 100
        tableView2.rowHeight = UITableView.automaticDimension
        
        // 忽略上方狀態欄
        tableView2.contentInsetAdjustmentBehavior = .never
        shopingView.isHidden = true
        seperateLine.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        //更新返回圖示
        let backButtonImage = UIImage(named: "Icons_44px_Back01")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
    }
    
//MARK: - Segue Setting
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShopCart" {
            if let destinationVC = segue.destination as? ShopingCartViewController {
                if commonProduct == nil {  //假設這邊還為空值 就再次進行轉換
                    if let product = receiveData {
                        commonProduct = convertToCommonProduct(from: product)
                    } else if let datum = receiveProduct {
                        commonProduct = convertToCommonProduct(from: datum)
                    }
                }
                
                destinationVC.commonProduct = self.commonProduct
                destinationVC.delegate = self //一定要指定給自己
                destinationVC.delegate4 = self
                shoppingCartView = destinationVC
            
            }
        }
    }
    
    //用於監測是否有新的資料存入CoreData
    func someFunctionThatModifiesCart() {
        NotificationCenter.default.post(name: NSNotification.Name("CartDidChange"), object: nil)
    }
    

    //將camelcase 轉為 common case
    //MARK: - Convert Case
    func convertToCommonProduct(from product: CamelCase.Product) -> CommonProduct {
        let variants = product.variants.map { CommonVariant(colorCode: $0.color_code, size: $0.size, stock: $0.stock) }
        let colors = product.colors.map { CommonColor(code: $0.code, name: $0.name) }

        return CommonProduct(
            id: product.id,
            category: product.category,
            title: product.title,
            description: product.description,
            price: product.price,
            texture: product.texture,
            wash: product.wash,
            place: product.place,
            note: product.note,
            story: product.story,
            mainImage: product.main_image,
            images: product.images,
            variants: variants,
            colors: colors,
            sizes: product.sizes
        )
    }

    func convertToCommonProduct(from datum: Productlist2.Datum) -> CommonProduct {
        let variants = datum.variants.map { CommonVariant(colorCode: $0.colorCode, size: $0.size, stock: $0.stock) }
        let colors = datum.colors.map { CommonColor(code: $0.code, name: $0.name) }

        return CommonProduct(
            id: datum.id,
            category: datum.category,
            title: datum.title,
            description: datum.description,
            price: datum.price,
            texture: datum.texture,
            wash: datum.wash,
            place: datum.place,
            note: datum.note,
            story: datum.story,
            mainImage: datum.mainImage,
            images: datum.images,
            variants: variants,
            colors: colors,
            sizes: datum.sizes
        )
    }

    
    func readyAddToCart() {
        addToCart.isEnabled = true
        addToCart.alpha = 1.0
        addToCart.backgroundColor = UIColor.black
        flag = 1 //讓按下按鈕的功能改變
        
    }
    
    func unreadyAddToCart() {
        addToCart.isEnabled = false
        addToCart.alpha = 0.5
        addToCart.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        addToCart.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        flag = 1 //讓按下按鈕的功能改變
        
    }
    
//MARK: - CoreData Func
    func saveToCoreData(selectedColor: String, selectedSize: String, selectNum: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newItem = ShopCartData(context: context)
        newItem.name = commonProduct?.title
        newItem.price = Int64(commonProduct?.price ?? 0)
        newItem.color = selectedColor
        newItem.size = selectedSize
        newItem.select = Int64(selectNum)
        newItem.stock = Int64(selectedStock!)
        newItem.image = commonProduct?.mainImage
        
        do {
            try context.save()
            print("Successfully saved to Core Data.")
        } catch {
            print("Failed to save to Core Data: \(error)")
        }
        updateBadgeNumber()  //存完coredata後，更新badge number
        
    }
    
    func getTotalItemCount() -> Int {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShopCartData> = ShopCartData.fetchRequest()
        
        do {
            let items = try context.fetch(fetchRequest) //已經在core data的
            var totalCount = 0
            for item in items {
                totalCount += Int(item.select) //將所有 以加入購物車的數量 計算總量
            }
            return totalCount
        } catch {
            print("failed to fetch: \(error)")
            return 0
        }
    }
    
//MARK: - Badge Setting
    func updateBadgeNumber() {
        let totalCount = getTotalItemCount()  //得到總量後
        
        if let tabBarItems = self.tabBarController?.tabBar.items {  //用於更新badge number
            let tabBarItem = tabBarItems[2] //用於更新購物車的badge
            if totalCount > 0 {
                tabBarItem.badgeValue = "\(totalCount)"
            } else {
                tabBarItem.badgeValue = nil
            }
            
        }
        
    }

    // 點擊cell 關閉按鈕時的function
// MARK: - HidecontenView Setting
    func hideContainerView() {
        
        shopingView.isHidden = true //這個頁面隱藏
        addToCart.isEnabled = true //按鈕的設定
        addToCart.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        addToCart.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        //將先前加入的遮蓋圖層去除
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = tableView2.cellForRow(at: indexPath) as? Cell3 {
            // 獲取 cell 內的 UIScrollView
            let scrollView = cell.scrollView
            //將遮蓋曾拿掉
            scrollView?.subviews.forEach{ subview in
                if subview.backgroundColor == UIColor.black.withAlphaComponent(0.5) {
                    subview.removeFromSuperview()
                }
            }
            
        }
        
        shoppingCartView?.resetColorSize()
        flag = 0
        
    }
    
    
    
//MARK: - TabBar Setting  ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 在 DetailViewController 消失時重新啟用 Tab Bar 並重新顯示它
        tabBarController?.tabBar.isHidden = false
        parentTabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
// MARK: - AddtoShopping Cart Setting
    @IBAction func addToShoppingCart(_ sender: Any) {
        
        if flag == 0 {
            shopingView.isHidden = false
            shopingView.layer.cornerRadius = 10 //設定圓角參數
            shopingView.clipsToBounds = true //啟用圓角
            
            let screenHeight = UIScreen.main.bounds.height //確定螢幕的高度
            shopingView.transform = CGAffineTransform(translationX: 0, y: screenHeight) //設定初始位置在螢幕下方
            
            UIView.animate(
                withDuration: 0.2, // 動畫持續時間
                delay: 0.0, // 延遲時間
                options: .curveEaseInOut, // 動畫選項，可以設定加速和減速效果
                animations: {
                    //                self.shopingView.alpha = 1 // 將透明度漸變到完全不透明
                    self.shopingView.transform = .identity
                },
                completion: nil // 動畫完成後的動作
            )
            
            
            //關閉加入購物車按鈕跟外觀改灰
            addToCart.isEnabled = false
            addToCart.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 0.5)
            addToCart.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            
            
            
            //為scrollview最前面增加一個遮蓋圖層，進入購物車時加入它
            let indexPath = IndexPath(row: 0, section: 0)
            if let cell = tableView2.cellForRow(at: indexPath) as? Cell3 {
                // 獲取 cell 內的 UIScrollView
                let scrollView = cell.scrollView
                
                // 添加半透明覆蓋層到 UIScrollView
                let coverView = UIView(frame: scrollView!.bounds)
                coverView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 設置黑色並調整透明度
                scrollView?.addSubview(coverView)
            }
            
        } else {
            shopingView.isHidden = true
            shoppingCartView?.resetColorSize()
            
            
            //將先前加入的遮蓋圖層去除
            let indexPath = IndexPath(row: 0, section: 0)
            if let cell = tableView2.cellForRow(at: indexPath) as? Cell3 {
                // 獲取 cell 內的 UIScrollView
                let scrollView = cell.scrollView
                //將遮蓋曾拿掉
                scrollView?.subviews.forEach{ subview in
                    if subview.backgroundColor == UIColor.black.withAlphaComponent(0.5) {
                        subview.removeFromSuperview()
                    }
                }
                
            }
            
//MARK: - StatusAlert Setting
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "Icons_44px_Success01")
            statusAlert.title = "Success"
            statusAlert.message = "Your operation was successful."
            statusAlert.canBePickedOrDismissed = true
            statusAlert.showInKeyWindow()
            

            saveToCoreData(selectedColor: self.selectedColor!, selectedSize: self.selectedSize!, selectNum: self.selectNum) //存入coreData
            someFunctionThatModifiesCart()
            flag = 0 //變回執行 進入購物車的功能
        }
        
    }
    
}
// MARK: - Delegate function
extension DetailPageViewController: ShopCell1Delegate {
    func resetOtherCellsSelection() {
       
    }
    
    func closeShoppingView() {
        hideContainerView()
    }
}

extension DetailPageViewController: ShoppingCartViewDelegate {
    func passSelectNum(num: Int) {
        selectNum = num
        
    }
    
    
    func passSelectColorSize(color: String, size: String,stock: Int) {
        selectedColor = color
        selectedSize = size
        selectedStock = stock
       
    }
    
    func disableToCart()  {
        unreadyAddToCart()
    }
    
    func resetColorSize() {
       unreadyAddToCart()
    }
    func didUpdateAddToCart() {
        readyAddToCart()
    }
}


extension DetailPageViewController: ShopCell4Delegate {
    func didselectnum(selectnum: Int) {
        self.selectNum = selectnum
    }
}



//MARK: - TableView Setting
extension DetailPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 500
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let product = commonProduct else {
            fatalError("commonProduct is nil")
        }
        
        // 得到 顏色的array
        let codes = product.colors.map { $0.code }
        
        // 得到圖片的url
        let images = product.images
        
        // 得到size array
        let sizes = product.sizes
        
        // 計算庫存總額
        let stockSum = product.variants.reduce(0) { $0 + $1.stock }
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! Cell3
            cell.configure(images: images)
            return cell
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! Cell4
            cell2.labelView1.text = product.title
            cell2.labelView2.text = "\(product.id)"
            cell2.labelView3.text = "NT$ \(product.price)"
            return cell2
        case 2:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! Cell5
            cell3.contetView.text = product.story
            return cell3
        case 3:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! Cell6
            cell4.nameLabelView.text = "顏色"
            cell4.addView2(colors: codes)
            return cell4
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! Cell7
            cell.nameLabel.text = "尺寸"
            cell.contentLabel.text = sizes.joined(separator: " - ")
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! Cell7
            cell.nameLabel.text = "庫存"
            cell.contentLabel.text = "\(stockSum)"
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! Cell7
            cell.nameLabel.text = "材質"
            cell.contentLabel.text = product.texture
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! Cell7
            cell.nameLabel.text = "洗滌"
            cell.contentLabel.text = product.wash
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! Cell7
            cell.nameLabel.text = "產地"
            cell.contentLabel.text = product.place
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! Cell7
            cell.nameLabel.text = "備註"
            cell.contentLabel.text = product.note
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! Cell7
            cell.nameLabel.text = ""
            return cell
        }
    }
}


//用於轉換hex的extension
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

