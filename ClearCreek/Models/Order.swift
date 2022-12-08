//
//  Order.swift
//  ClearCreek
//
//  Created by Student on 28/09/2022.
//

import Foundation

struct Order : Codable {
    
    var key: String?
    var order_status: Int?
    var order_id: String?
    var order_items: [OrderItem]?
    var payment_method: String?
    var payment_method_name: String?
    var tax_amount: Double?
    var total_amount: Double?
    var date: String?
    var user_id: String?
    
    init() {}
}

struct OrderItem : Codable {
    
    var id: String?
    var name: String?
    var comment: String?
    var price: Double?
    var quantity: Int?
    var image: String?
    var toppings: String?
    var variant: String?
    
    init() {}
}
