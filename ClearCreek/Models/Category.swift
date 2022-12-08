//
//  Category.swift
//  ClearCreek
//
//  Created by Student on 26/09/2022.
//

import Foundation

struct Category {
    
    var id: Int?
    var name: String?
    var products: [ProductModel]?
    
    init() {}
}


struct ProductModel {
    
    var key: String?
    var id: String?
    var bread: String?
    var image: String?
    var name: String?
    var perToppingPrice: Double?
    var price: Double?
    var toppings: [String]?
    var variants: [VariantModel]?
    
    init() {}
}


struct VariantModel : Codable {
    
    var name: String?
    var price: Double?
    
    init() {}
}
