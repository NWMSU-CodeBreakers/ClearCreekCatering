//
//  Admin.swift
//  ClearCreek
//
//  Created by Ali Sher on 02/12/2022.
//

import Foundation

struct Admin : Codable {
    
    var id: String?
    var email: String?
    var password: String?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        
        case email = "email"
        case password = "password"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
    }
}
