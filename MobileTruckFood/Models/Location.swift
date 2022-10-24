//
//  Location.swift
//  MobileTruckFood
//
//  Created by Student on 27/09/2022.
//

import Foundation
import CoreLocation

struct LocationModel: Codable {
    
    var id: Int?
    var name: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
    }
}
