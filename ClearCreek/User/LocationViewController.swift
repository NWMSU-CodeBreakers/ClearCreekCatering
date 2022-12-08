//
//  LocationViewController.swift
//  ClearCreek
//
//  Created by Student on 13/09/2022.
//

import UIKit
import GoogleMaps
import FirebaseDatabase


class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    var locationsList: [LocationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location"
        self.getLocation()
    }
    
    func getLocation() -> Void {
        
        
        FirebaseTables.Locations.observe(.value) { snapshot in
            
            self.locationsList.removeAll()
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var dict = NSMutableDictionary()
                dict = dic.mutableCopy() as! NSMutableDictionary
                dict.setValue(snap.key, forKey: "id")
                
                var model = LocationModel()
                model.id = snap.key
                model.name = dict["name"] as? String ?? ""
                model.address = dict["address"] as? String ?? ""
                model.latitude = dict["latitude"] as? Double ?? 0.0
                model.longitude = dict["longitude"] as? Double ?? 0.0
                self.locationsList.append(model)
                
            }
            self.drawTrucksOnMap()
        }
    }
    
    func drawTrucksOnMap() {
        
        var bounds = GMSCoordinateBounds()
        
        for i in 0..<locationsList.count {
            
            let location = locationsList[i]
            
            let lat = location.latitude ?? 0.0
            let lng = location.longitude ?? 0.0
            
            let markerPosition = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let marker = GMSMarker(position: markerPosition)
            marker.icon = UIImage(named: "Marker")
            marker.title = location.name ?? ""
            marker.map = mapView
            
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100.0 , left: 100.0 ,bottom: 100.0 ,right: 100.0)))
    }
}
