//
//  productlistManager.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/25.
//

import Foundation
import Alamofire

struct Productlist: Codable {
    let data: [Datum]
    let nextPaging: Int?
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextPaging = "next_paging"
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let id: Int
        let category, title, description: String
        let price: Int
        let texture, wash, place, note: String
        let story: String
        let mainImage: String
        let images: [String]
        let variants: [Variant]
        let colors: [Color]
        let sizes: [Size]
        
        enum CodingKeys: String, CodingKey {
            case id, category, title, description, price, texture, wash, place, note, story
            case mainImage = "main_image"
            case images, variants, colors, sizes
        }
    }
    
    // MARK: - Color
    struct Color: Codable {
        let code, name: String
    }
    
    enum Size: String, Codable {
        case l = "L"
        case m = "M"
        case s = "S"
    }
    
    // MARK: - Variant
    struct Variant: Codable {
        let colorCode: String
        let size: Size
        let stock: Int
        
        enum CodingKeys: String, CodingKey {
            case colorCode = "color_code"
            case size, stock
        }
    }
    
}


import Foundation

// MARK: - Productlist2
struct Productlist2: Codable {
    let data: [Datum]
    
    
    // MARK: - Datum
    struct Datum: Codable {
        let id: Int
        let category, title, description: String
        let price: Int
        let texture, wash, place, note: String
        let story: String
        let mainImage: String
        let images: [String]
        let variants: [Variant]
        let colors: [Color]
        let sizes: [String]
        
        enum CodingKeys: String, CodingKey {
            case id, category, title, description, price, texture, wash, place, note, story
            case mainImage = "main_image"
            case images, variants, colors, sizes
        }
    }
    
    // MARK: - Color
    struct Color: Codable {
        let code, name: String
    }
    
    // MARK: - Variant
    struct Variant: Codable {
        let colorCode, size: String
        let stock: Int
        
        enum CodingKeys: String, CodingKey {
            case colorCode = "color_code"
            case size, stock
        }
    }
    
}

protocol ProdictListDelegate :AnyObject{

    func manager(_ manager: ProductListManager, didGet products: [Productlist2])
    
    func manager(_ manager: ProductListManager, didLoadMore products: [Productlist2])
    
    func manager(_ manager: ProductListManager, didFailWith error: Error)
}


class ProductListManager  {
    
    weak var delegate : ProdictListDelegate?
    
    func fetchProductList(url: String) {
        let durl = url
        
        AF.request(durl).responseDecodable(of: Productlist2.self) { response in  //decode 成設定的struct
            switch response.result {
            case .success(let productList):
                self.delegate?.manager(self, didGet: [productList])
                // 傳回得到的數值
            case .failure(let error):
                self.delegate?.manager(self, didFailWith: error)
                // 顯示錯誤訊息
            }
        }
    }
    
    func fetchMoreData(url: String) {
        
        let durl = url
        
        AF.request(durl).responseDecodable(of: Productlist2.self) { response in  //decode 成設定的struct
            switch response.result {
            case .success(let productList):
                self.delegate?.manager(self, didLoadMore: [productList])
                // 傳回得到的數值
            case .failure(let error):
                self.delegate?.manager(self, didFailWith: error)
                // 顯示錯誤訊息
            }
        }
        
    }
    
    
}


    
    
    
    
    
    

