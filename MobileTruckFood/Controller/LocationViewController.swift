//
//  LocationViewController.swift
//  MobileTruckFood
//
//  Created by Student on 13/09/2022.
//

import UIKit
//import FirebaseFirestore
import MapKit



class LocationViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    var locationsList: [LocationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location"
        self.getLocation()
    }
    
    func getLocation() -> Void {
        
        let decoder = JSONDecoder()
        FirebaseTables.Locations.observe(.value) { snapshot in
            
            guard let data = snapshot.data else { return }
            do{
                let result = try decoder.decode([LocationModel].self, from: data)
                print(result )
                
                self.locationsList = result
                self.drawTrucksOnMap()
            }catch{
                print("errpr 2")
                print(error.localizedDescription)
            }
        }
    }
    
    func drawTrucksOnMap() {
        
        var count = 0
        
        for truck in self.locationsList {
            
            if count == 0 {
                
                let point = CLLocationCoordinate2D(latitude: truck.latitude ?? 0.00, longitude: truck.longitude ?? 0.00)
                let viewRegion = MKCoordinateRegion(center: point, latitudinalMeters: 200, longitudinalMeters: 200)
                self.map.setRegion(viewRegion, animated: true)
                
                count += 1
            }
            
            let annotations = MKPointAnnotation()
            annotations.title = truck.name
            annotations.coordinate = CLLocationCoordinate2D(latitude:
                                                                truck.latitude ?? 0.0, longitude: truck.longitude ?? 0.0)
            map.addAnnotation(annotations)
        }
    }
}
