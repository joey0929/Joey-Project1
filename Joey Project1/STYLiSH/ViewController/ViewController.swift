//
//  ViewController.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/17.
//

import UIKit
import Kingfisher
import MJRefresh
import CoreData

class ViewController:  UIViewController ,MarketManagerDelegate ,UITabBarControllerDelegate{
    
    @IBOutlet weak var imageView1: UIImageView! //標題的圖示
    @IBOutlet weak var tableView: UITableView!
    var marketManager = MarketManager()
    var datas : [CamelCase.Datas] = []//用於儲存data
    var badgeNum : Int = 0
    var cartItems: [ShopCartData] = [] //firstPage 用於接下CoreData的資料
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //用於CoreData
    var loginPopupView: UIView?
    var flag = 0 // 禁用tableview cell點擊狀態
    var previousSelectedIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self   //將delegate 設置給這個ViewController
        tableView.dataSource = self //將datasource 設置給這個ViewController
        tableView.allowsSelection = true //未開啟的話無法正常啟用segue
        
        marketManager.delegate = self
        marketManager.fetchMarketingHots()
        
        //將back button 取消掉back字樣
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        
        //初始先更新好先前的coreData殘存的數量資料
        fetchCartItems()
        updateBadgeNumber()
        
        
        // 設定下拉的套件
        MJRefreshConfig.default.languageCode = "en" //顯示英文下拉資訊
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
    
        
        tabBarController?.delegate = self
       
    }
    
    @objc func refreshData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.mj_header?.endRefreshing()
            self.marketManager.fetchMarketingHots() //再fetch一次
                    }
    }
    
    
    func manager(_ manager: MarketManager, didGet marketingHots: CamelCase) {
        
        self.datas = marketingHots.data //將得到的資料帶入創建出來的array裡面
        DispatchQueue.main.sync { //在主線程更新UI
            self.tableView.reloadData() //reload tableview
        }
       
    }
    
    func manager(_ manager: MarketManager, didFailWith error: any Error) {
        print("error")
    }
    
    
//MARK: - Badge Setting
    func fetchCartItems() {  //先從CoreData取資料
        
        let fetchRequest: NSFetchRequest<ShopCartData> = ShopCartData.fetchRequest()
        
        do {
            cartItems = try context.fetch(fetchRequest)
               
        } catch {
            print("Failed to fetch latest data: \(error)")
        }
       
    }
    
    func updateBadgeNumber() {  //更新badge數量
          let totalCount = getTotalItemCount()
          
          if let tabBarItems = self.tabBarController?.tabBar.items {
              let tabBarItem = tabBarItems[2]
              
              if totalCount > 0 {
                  tabBarItem.badgeValue = "\(totalCount)"
              } else {
                  tabBarItem.badgeValue = nil
              }
          }
      }
      
    func getTotalItemCount() -> Int {  //計算item中的選擇數量
        let fetchRequest: NSFetchRequest<ShopCartData> = ShopCartData.fetchRequest()
        
        do {
            let items = try context.fetch(fetchRequest)
            var totalCount = 0
            for item in items {
                totalCount += Int(item.select)
            }
            return totalCount
        } catch {
            print("Failed to fetch items from Core Data: \(error)")
            return 0
        }
    }
// MARK: - Login Popup

    func showLoginPopup() {
        tabBarController?.tabBar.isHidden = true  //先隱藏tabbar
        navigationController?.setNavigationBarHidden(true, animated: false)
      //  imageView1.isHidden = true
       
        let containerView = UIView()  //建立一個可以包住遮罩跟彈窗的view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        let overlayView = UIView() //建立遮罩
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 遮罩alpha 設定
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -170) //設定遮罩範圍
        ])
        
        let popupView = UIView()  //彈窗的部分
        popupView.backgroundColor = UIColor.white
        popupView.layer.cornerRadius = 5
        popupView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(popupView)
        self.loginPopupView = popupView

        let titleLabel = UILabel()
        titleLabel.text = "請先登入會員"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left  // 讓標題靠左對齊
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(titleLabel)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "Icons_24px_Close"), for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(dismissLoginPopup), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(closeButton)
        
        let messageLabel = UILabel()
        messageLabel.text = "登入會員後即可使用個人功能。"
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textAlignment = .left  // 讓訊息靠左對齊
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(messageLabel)
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(hex: "#CCCCCC")
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(separatorLine)
        
        let loginButton = UIButton()
        loginButton.setTitle("Facebook登入", for: .normal)
        //loginButton.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        loginButton.backgroundColor = UIColor(red: 0.16, green: 0.45, blue: 0.73, alpha: 1.00)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(loginButton)

        NSLayoutConstraint.activate([
            popupView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            popupView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            popupView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            popupView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),

            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant:182),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            
            separatorLine.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            separatorLine.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            separatorLine.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            loginButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 10),
            loginButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        UIView.animate(withDuration: 0.2) {
            popupView.transform = .identity
        }
    }

    @objc func dismissLoginPopup() {
        guard let loginPopupView = loginPopupView else { return }
        guard let containerView = loginPopupView.superview else { return }

        UIView.animate(withDuration: 0.3, animations: {
            loginPopupView.transform = .identity
        }) { _ in
            containerView.removeFromSuperview()  // 移除包住整個遮罩的view和彈窗
            self.tabBarController?.tabBar.isHidden = false
            self.loginPopupView = nil
        }
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        flag = 0 // 開啟cell 可以被點擊
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 確認選中的Tab
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            // 如果選中的是Tab 4，且上次選擇的是Tab 1或Tab 2，則顯示彈窗
            if index == 3 && (previousSelectedIndex == 0 || previousSelectedIndex == 1) {
                // 顯示彈窗並返回到上一次選擇的Tab
                showLoginPopup()
                tabBarController.selectedIndex = previousSelectedIndex
            } else {
                // 正常切換Tab並記錄選中的索引
                previousSelectedIndex = index
            }
        }
    }
    
//MARK: - UITabBarControllerDelegate
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if let index = tabBarController.viewControllers?.firstIndex(of: viewController), index == 3 {
//            flag = 1
//            showLoginPopup()
//            tableView.reloadData()
//            return false
//        }
//        return true
//    }

}

//MARK: - TableView Setting
extension ViewController :  UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {  //用於設置幾個section
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  //用於一個section中要顯示幾個row
        return datas[section].products.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  //用於顯示於row的cell
        let product = datas[indexPath.section].products[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! Cell1
        //要輸入在先前創立的cell的identifier
        cell.imageView1.kf.setImage(with: URL(string: product.main_image))
        cell.Label1.text = product.title
        cell.Label2.text = product.description
        
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! Cell2
        cell2.imageView2.kf.setImage(with: URL(string: product.images[0]))
        cell2.imageView3.kf.setImage(with: URL(string: product.images[1]))
        cell2.imageView4.kf.setImage(with: URL(string: product.images[2]))
        cell2.imageView5.kf.setImage(with: URL(string: product.images[3]))
        cell2.Label3.text = product.title
        cell2.Label4.text = product.description

        if indexPath.row % 2 == 0 {
            return cell
        }
        else {
            return cell2
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = .white // 設置背景顏色
            
            let headerLabel = UILabel()
        
            headerLabel.text = datas[section].title //更新header label
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            headerLabel.textColor = .black // 設置字體顏色
            headerLabel.font = UIFont.boldSystemFont(ofSize: 18) // 設置字體大小跟設為粗體字
            headerView.addSubview(headerLabel)
            
            // 設置headerLabel的constraint
            NSLayoutConstraint.activate([
                headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
                headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
            return headerView
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailPage", sender: indexPath)
    }
     
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if flag == 1 {
            return nil
        }
        return indexPath
    }
    
    
    
//MARK: - Segue Setting
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //資料傳值
        if segue.identifier == "toDetailPage" {
            if let indexPath = sender as? IndexPath {
                let product = datas[indexPath.section].products[indexPath.row]
                
                if let destinationVC = segue.destination as? DetailPageViewController {   //將資料傳入Detail VC
                    destinationVC.receiveData = product
                }
            }
            self.tabBarController?.tabBar.isHidden = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
    }
    
    
    
 
}
