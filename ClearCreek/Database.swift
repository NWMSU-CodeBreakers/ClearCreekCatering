//
//  Database.swift
//  ClearCreek
//
//  Created by Student on 18/09/2022.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class FirebaseTables: NSObject {
    
    static var Admin: DatabaseReference {
        return Database.database().reference().child("admin")
    }
    
    static var Categries: DatabaseReference {
        return Database.database().reference().child("categories")
    }
    
    static var Locations: DatabaseReference {
        return Database.database().reference().child("locations")
    }
    
    static var Orders: DatabaseReference {
        return Database.database().reference().child("orders")
    }
}
