//
//  SecondViewController.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/18.
//

import UIKit
import MJRefresh
import Alamofire
import Kingfisher


class SecondViewController: UIViewController {

    @IBOutlet weak var collectionView2: UICollectionView!
    var productListManager = ProductListManager()
    var productsData : [Productlist2.Datum] = []
    
    
    var isMorePage = true
    var cPage = 0 //current分頁
    
    
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    var selectionLine = UIView()
    var urls = ["https://api.appworks-school.tw/api/1.0/products/women","https://api.appworks-school.tw/api/1.0/products/men",
                "https://api.appworks-school.tw/api/1.0/products/accessories"]
    var flag = 0 //用於爬取不同的url資料
    
    var loginPopupView: UIView? //用於彈窗測試
    var flag2 = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "型錄"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView2.dataSource = self
        collectionView2.delegate = self
        productListManager.delegate = self
        
        setUIButton()
        addToView()
        configure()
        
        //MJRefreshConfig.default.languageCode = "en" //顯示英文加載狀態
        headerAndFooter() //初始化header and footer
        productListManager.fetchProductList(url:urls[0])
    }
    
    func headerAndFooter() {
        // 設定下拉的套件
        collectionView2.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        // 設定上拉load的套件
        collectionView2.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerRefresh))
        
    }
    
    @objc func refreshData() {

        cPage = 0
        isMorePage = true
        collectionView2.mj_footer?.resetNoMoreData() //下拉更新時reset它
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 數據更新
            let url = String(self.urls[self.flag])
            self.productListManager.fetchProductList(url: url) //再fetch一次
            self.collectionView2.mj_header?.endRefreshing()
        }

    }
    
    @objc func footerRefresh() {
            
            if self.isMorePage == true {
                self.cPage += 1
                let urlPage = String(self.urls[self.flag] + "?paging=\(self.cPage)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.productListManager.fetchMoreData(url: urlPage)
                }
            } else {
                self.collectionView2.mj_footer?.endRefreshingWithNoMoreData()
            }
            
    }
    
    //用於tabbar線條動畫
    var indicatorWidthConstraint: NSLayoutConstraint?
    var indicatorLeadingConstraint: NSLayoutConstraint?
    
    
    // MARK: - Select Action
    @objc func tabSelected(_ sender: UIButton) {
        
        // 動畫更新
        UIView.animate(withDuration: 0.3) {
            self.indicatorLeadingConstraint?.isActive = false
            if sender == self.button1 {
                self.indicatorLeadingConstraint = self.selectionLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            } else if sender == self.button2 {
                self.indicatorLeadingConstraint = self.selectionLine.leadingAnchor.constraint(equalTo: self.button1.trailingAnchor)
            } else if sender == self.button3 {
                self.indicatorLeadingConstraint = self.selectionLine.leadingAnchor.constraint(equalTo: self.button2.trailingAnchor)
            }
            self.indicatorLeadingConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
        
        // 根據選中按鈕來切換內容
        let selectColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        if sender == button1 {
            button1.setTitleColor(selectColor, for: .normal)
            button2.setTitleColor(.gray, for: .normal)
            button3.setTitleColor(.gray, for: .normal)
            flag = 0
            productListManager.fetchProductList(url:urls[flag])
        } else if sender == button2 {
            button1.setTitleColor(.gray, for: .normal)
            button2.setTitleColor(selectColor, for: .normal)
            button3.setTitleColor(.gray, for: .normal)
            flag = 1
            productListManager.fetchProductList(url:urls[flag])
            
        } else if sender == button3 {
            button1.setTitleColor(.gray, for: .normal)
            button2.setTitleColor(.gray, for: .normal)
            button3.setTitleColor(selectColor, for: .normal)
            flag = 2
            productListManager.fetchProductList(url:urls[flag])

        }
    }
    
    
    
}


        
extension SecondViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - CollectionView Setting
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productsData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if (flag2 == 1) {
            return false
        } else {
            return true
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! SecondCell
        
        let index = indexPath.row //indexPath[section,row]
        
        let product = productsData[index]
        cell.imageView.kf.setImage(with: URL(string: product.mainImage))
        cell.label1.text = product.title
        cell.label2.text = String(product.price)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       // 設置 section 的邊距
       return UIEdgeInsets(top: 16, left: 22, bottom: 16, right: 22)
    }
        
    
    //固定item 大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: 164, height: 282)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //測試資料傳值
        
        if segue.identifier == "catLogtoDetailPage" {
            if let indexPath = sender as? IndexPath {
                
                let product = productsData[indexPath.row]
                if let destinationVC = segue.destination as? DetailPageViewController {
                    destinationVC.receiveProduct = product
                }
            }
            self.tabBarController?.tabBar.isHidden = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
    }
    
    
    
}

extension SecondViewController: ProdictListDelegate {
    // MARK: -  ProductList Delegate
    func manager(_ manager: ProductListManager, didGet products: [Productlist2]) {
        self.productsData = products[0].data
        collectionView2.reloadData()
        isMorePage = true
        
    }
    
    func manager(_ manager: ProductListManager, didLoadMore products: [Productlist2]) {
        
        if products[0].data.isEmpty {
            self.isMorePage = false
            collectionView2.mj_footer?.endRefreshingWithNoMoreData()
        } else {
            
            self.productsData.append(contentsOf: products[0].data)
            collectionView2.reloadData()
            collectionView2.mj_footer?.endRefreshing()
//            isMorePage = true
        }
    }
    
    func manager(_ manager: ProductListManager, didFailWith error: any Error) {
        print("error")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "catLogtoDetailPage", sender: indexPath)
    }
}


extension SecondViewController {
    //MARK: UISetting
    func addToView() {
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(selectionLine)
    }
    
    //MARK: - setUIButton
    func setUIButton() {
        
        button1.setTitle("女裝", for: .normal)
        button1.setTitleColor(UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1), for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button1.backgroundColor = .white
        button1.addTarget(self, action: #selector(tabSelected(_:)), for: .touchUpInside)
        button1.translatesAutoresizingMaskIntoConstraints = false
        
        button2.setTitle("男裝", for: .normal)
        button2.setTitleColor(.lightGray, for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button2.backgroundColor = .white
        button2.addTarget(self, action: #selector(tabSelected(_:)), for: .touchUpInside)
        button2.translatesAutoresizingMaskIntoConstraints = false
        
        button3.setTitle("配件", for: .normal)
        button3.setTitleColor(.lightGray, for: .normal)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button3.backgroundColor = .white
        button3.addTarget(self, action: #selector(tabSelected(_:)), for: .touchUpInside)
        button3.translatesAutoresizingMaskIntoConstraints = false

        selectionLine.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        selectionLine.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    // MARK: - Button and Line Constrains
    func configure() {
        NSLayoutConstraint.activate([
            button1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            button1.heightAnchor.constraint(equalToConstant: 44),
            
            // button1 的leading 等於view的leading，就是說按鈕左邊與這個view對齊
            //第二行為 按鈕的上邊緣與view的上邊緣對齊  第三為設定寬度為整個view的1/3 因為有三個按鈕
            //最後為設定高度
            
            button2.leadingAnchor.constraint(equalTo: button1.trailingAnchor),
            button2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            button2.heightAnchor.constraint(equalToConstant: 44),
            
            button3.leadingAnchor.constraint(equalTo: button2.trailingAnchor),
            button3.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            button3.heightAnchor.constraint(equalToConstant: 44),
            
            selectionLine.topAnchor.constraint(equalTo: button1.bottomAnchor),
            selectionLine.heightAnchor.constraint(equalToConstant: 1)
            //設定線條初始位置固定在button1下方  並設置它的height為1
        ])
        
        //初始化下方線條的寬度與button1相同 線的左邊界等於這個view的左邊屆
        indicatorWidthConstraint = selectionLine.widthAnchor.constraint(equalTo: button1.widthAnchor)
        indicatorLeadingConstraint = selectionLine.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        indicatorWidthConstraint?.isActive = true
        indicatorLeadingConstraint?.isActive = true
    }
    
}
