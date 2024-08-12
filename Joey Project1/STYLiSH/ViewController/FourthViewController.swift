//
//  FourthViewController.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/23.
//

import UIKit

class FourthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    // MARK: Data Array
    let itemsSection1 = ["待付款", "待簽收", "待簽收", "待評價", "退換貨"]
    let itemsSection2 = ["收藏", "到貨通知", "帳戶退款", "地址", "客服訊息","系統回饋", "手機綁定", "設定"]
    let imageInSection1 = ["Icons_24px_AwaitingPayment","Icons_24px_AwaitingShipment","Icons_24px_Shipped","Icons_24px_AwaitingReview","Icons_24px_Exchange"]
    let imageInSection2 = ["Icons_24px_Starred","Icons_24px_Notification","Icons_24px_Refunded","Icons_24px_Address","Icons_24px_CustomerService","Icons_24px_SystemFeedback","Icons_24px_RegisterCellphone","Icons_24px_Settings"]
    
    
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView7: UIImageView! // 頭像
    
    
    // MARK: DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageView7.layer.cornerRadius = 30 //圖片做圓角
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView") //註冊一個headerview
    }
    
    
    // MARK: Session Setting

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 8
        }
    }
    
    // MARK: Datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! FirstCell
        
        if indexPath.section == 0 {
            cell.label5.text = itemsSection1[indexPath.row]
            cell.imageView6.image = UIImage(named: imageInSection1[indexPath.row])
        } else {
            cell.label5.text = itemsSection2[indexPath.row]
            cell.imageView6.image = UIImage(named: imageInSection2[indexPath.row])
        }
       
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           // 設置行間距
           return 20
       }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       if section == 0 {
           return (collectionView.bounds.width - 332) / 5
       } else {
           return (collectionView.bounds.width - 272 ) / 4
       }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       // 設置 section 的邊距
       return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
        
    
    //固定item 大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       
       return CGSize(width: 60, height: 50)
    }
    
    // 提供 header view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
        headerView.backgroundColor = .white // 設置 header 背景顏色
        

        //header label1
        let padding: CGFloat = 20
        let label = UILabel(frame: CGRect(x: padding, y: 0, width: headerView.bounds.width - 2 * padding, height: headerView.bounds.height))
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        
        
        //header label2
        let label2 = UILabel(frame: CGRect(x: padding, y: 0, width: headerView.bounds.width - 2 * padding, height: headerView.bounds.height))
        label2.textAlignment = .right
        label2.textColor = .black
        label2.font = UIFont.systemFont(ofSize: 14)
        label2.text = "查看全部 >"
        
        if indexPath.section == 0 {
            label.text = "我的訂單"
            headerView.addSubview(label2)
        } else {
            label.text = "更多服務"
        }
        

        headerView.addSubview(label)
        
        return headerView
    }

    
}
