//
//  Category.swift
//  MobileTruckFood
//
//  Created by Student on 26/09/2022.
//

import Foundation

struct Category : Codable {
    
    var id: Int?
    var name: String?
    var products: [ProductModel]?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case products = "products"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        products = try values.decodeIfPresent([ProductModel].self, forKey: .products)
    }
}


struct ProductModel : Codable {
    
    var id: Int?
    var bread: String?
    var image: String?
    var name: String?
    var perToppingPrice: Double?
    var price: Double?
    var toppings: [String]?
    var variants: [VariantModel]?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case bread = "bread"
        case image = "image"
        case name = "name"
        case perToppingPrice = "perToppingPrice"
        case price = "price"
        case toppings = "toppings"
        case variants = "variants"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        bread = try values.decodeIfPresent(String.self, forKey: .bread)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        perToppingPrice = try values.decodeIfPresent(Double.self, forKey: .perToppingPrice)
        toppings = try values.decodeIfPresent([String].self, forKey: .toppings)
        variants = try values.decodeIfPresent([VariantModel].self, forKey: .variants)
        
        if (try? values.decodeIfPresent(Double.self, forKey: .price)) == nil {
            
            let range = try values.decodeIfPresent(Int.self, forKey: .price) ?? 0
            price = Double(range)
            
        } else {
            
            price = try values.decodeIfPresent(Double.self, forKey: .price)
        }
    }
}


struct VariantModel : Codable {
    
    var name: String?
    var price: Double?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case price = "price"
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
