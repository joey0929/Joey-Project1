//
//  marketManager.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/22.
//

import UIKit


struct CamelCase : Codable { // 定義struct
    let data : [Datas]
    
    struct Datas : Codable {
        let title : String
        let products: [Product]
    }


    struct Product : Codable {  //for products
        let id: Int
        let category:String
        let title: String
        let description:String
        let price : Int
        let texture: String
        let wash : String
        let place : String
        let note: String
        let story : String
        let main_image : String
        let images: [String]
        let variants : [Image]
        let colors : [Color]
        let sizes : [String]
        
    }

    struct Image : Codable { //for variants
        let color_code : String
        let size : String
        let stock : Int
    }

    struct Color :Codable { //for colors
        let code: String
        let name: String
    }

    
    
}


enum GetError: Error {
    case emptyURL
//    case emptyData
}

protocol MarketManagerDelegate :AnyObject{

    func manager(_ manager: MarketManager, didGet marketingHots: CamelCase)

    func manager(_ manager: MarketManager, didFailWith error: Error)
}

class MarketManager {
    

    weak var delegate : MarketManagerDelegate? //設定delegate
    
    func getMarketingHots() async throws -> CamelCase {  //成功時回傳抓到的資料，失敗時丟出錯誤
        let url = "https://api.appworks-school.tw/api/1.0/marketing/hots"
        guard let request = URL(string: url) else {
            throw GetError.emptyURL
        }
        
        let (data, _) =  try await URLSession.shared.data(from: request)
        let decoder = JSONDecoder()
        let deCodeData = try decoder.decode(CamelCase.self, from: data)
        return deCodeData
    }
    
    func fetchMarketingHots() { //將資料用delegate傳出
        Task {
            do {
                let marketingHots  = try await getMarketingHots() //將抓到的資料丟入變數中
                delegate?.manager(self, didGet: marketingHots) //以delegate 方式將資料傳出
            }
            catch {
                delegate?.manager(self, didFailWith: error)
            }
        }
        
    }
    
    
}

