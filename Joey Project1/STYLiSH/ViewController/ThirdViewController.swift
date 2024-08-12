//
//  ThirdViewController.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/23.
//

import UIKit
import CoreData
import Kingfisher


class ThirdViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var cartItems: [ShopCartData] = [] //用於接下CoreData的資料
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cellCount = 0
    var changeNumber = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "購物車"
        checkCartItem()
        fetchCartItems()
        updateBadgeNumber()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchCartItems()
        updateBadgeNumber()
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartChange), name: NSNotification.Name("CartDidChange"), object: nil) //用於監測CoreData的狀態改變

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        checkCartItem()
    }
    
    func checkCartItem() {
        if cartItems.count < 1 {
            checkoutButton.alpha = 0.5
            checkoutButton.isEnabled = false
        } else {
            checkoutButton.alpha = 1.0
            checkoutButton.isEnabled = true
        }
    }
    
    
    @objc func handleCartChange() {
        fetchCartItems()
        checkCartItem()
        updateBadgeNumber()
        tableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("CartDidChange"), object: nil)
    }
    
    
    
    func fetchCartItems() {
        
        let fetchRequest: NSFetchRequest<ShopCartData> = ShopCartData.fetchRequest()
        
        do {
            cartItems = try context.fetch(fetchRequest)
               
        } catch {
            print("Failed to fetch latest data: \(error)")
        }
       
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFinalCart" {
            if let destinationVC = segue.destination as? ViewController2 {
                destinationVC.cartItems2 = self.cartItems
                
            }
            
        }
    }
    
}

// MARK: - TableView Setting
extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! CartCell1
        
        
        let item = cartItems[indexPath.row]
        //changeNumber = Int(item.select) * changeNumber
        cell.colorView.backgroundColor = UIColor(hex: item.color ?? "")
        cell.sizeLabel.text = item.size
        cell.imageview1.kf.setImage(with: URL(string: item.image ?? ""))
        cell.textField1.text = String(item.select)
        cell.priceLabel.text = String(item.price * item.select)
        cell.maxNum = Int(item.stock)
        cell.minNum = 1 
//        cell.priceLabel.text = String(changeNumber)
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.updateButtonStates(for: Int(item.select))
        
        return cell
        
    }
    
    
}

//MARK: - Delegate Setting
extension ThirdViewController: CustomCellDelegate {
    
    func didupdateBadge() { //用於更新badge
        updateBadgeNumber()
    }
    
    func updateBadgeNumber() {
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
      
      func getTotalItemCount() -> Int {
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
    
    func didChangeNum(change: Int,at indexPath: IndexPath) {
        guard indexPath.row < cartItems.count else {
             print("Index out of range")
             return
         }
         
         let item = cartItems[indexPath.row]
         
         
         item.select = Int64(change) //更新選擇的數量
         
         
         let originalPrice = item.price / item.select //先除回去初始價格
         item.price = originalPrice * Int64(change)  //再去計算
         
         // 保存更新后的数据
         do {
             try context.save()
         } catch {
             print("Failed to save context after quantity update: \(error.localizedDescription)")
         }
         
         // 刷新表格中的指定行
         tableView.reloadRows(at: [indexPath], with: .none)
        
        
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {

        
        
        guard indexPath.row < cartItems.count else {
            print("Index out of range")
            return
        }
        
        
        let itemToDelete = cartItems[indexPath.row]
        context.delete(itemToDelete)
        
        do {
            try context.save()
        } catch {
            print("Failed to save context after deletion: \(error.localizedDescription)")
        }

        cartItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        checkCartItem()
        updateBadgeNumber()
        tableView.reloadData()
        
        
        
    }
    
    
    
    
    
    
    
}
