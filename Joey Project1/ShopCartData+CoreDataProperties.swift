//
//  ShopCartData+CoreDataProperties.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/8/7.
//
//

import Foundation
import CoreData


extension ShopCartData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopCartData> {
        return NSFetchRequest<ShopCartData>(entityName: "ShopCartData")
    }

    @NSManaged public var color: String?
    @NSManaged public var count: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Int64
    @NSManaged public var select: Int64
    @NSManaged public var size: String?
    @NSManaged public var stock: Int64

}

extension ShopCartData : Identifiable {

}
