//
//  AddUpdateLocationVC.swift
//  AdminApp
//
//  Created by Ali Sher on 28/11/2022.
//

import UIKit
import GoogleMaps
import FirebaseDatabase

class AddUpdateLocationVC: UIViewController {
    
    var locationManager = CLLocationManager()
    var myLocation = CLLocation()
    var location: LocationModel?
    
    var selectedAddress = ""
    var selectedLat = 0.0
    var selectedLng = 0.0
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet var addUpdateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        
        addressTF.isUserInteractionEnabled = false
        if location == nil {
            
            self.initializeLocationManager()
            self.navigationItem.title = "Select Location"
        }else{
            
            self.addUpdateBtn.setTitle("Update", for: .normal)
            self.navigationItem.title = "Update Location"
            nameTF.text = location?.name ?? ""
            self.navigationItem.title = location?.name ?? ""
            self.addressTF.text = location?.address
            setLocation()
        }
    }
    
    func initializeLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    
    func setLocation() -> Void {
        
        let point = CLLocationCoordinate2D(latitude: location?.latitude ?? 0.00, longitude: location?.longitude ?? 0.00)
        
        let camera = GMSCameraPosition.camera(withLatitude: point.latitude, longitude: point.longitude, zoom: 15)
        self.mapView?.animate(to: camera)
        
    }
    
    func setCurrentLocation() -> Void {
        
        let point = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: point.latitude, longitude: point.longitude, zoom: 15)
        self.mapView?.animate(to: camera)
    }
    
    @IBAction func addUpdateBtnClicked(_ sender: Any) {
        
        if nameTF.text == "" {
            
            self.showAlert(msg: "Please enter location")
            return
        }
        
        let params = ["name": nameTF.text!,
                      "address": addressTF.text ?? "",
                      "latitude": selectedLat,
                      "longitude": selectedLng] as [String : Any]
        
        self.showSpinner(onView: self.view)
        
        if location == nil {
            
            self.addNewLocation(params: params)
        }else{
            
            self.updateLocation(params: params)
        }
    }
    
    func addNewLocation(params: [String: Any]) -> Void {
        
        FirebaseTables.Locations.childByAutoId().setValue(params){
            (error:Error?, ref:DatabaseReference) in
            if error == nil {
                
                self.removeSpinner()
                
                let alert = UIAlertController(title: "", message: "Address added successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
                
            } else {
                
                self.removeSpinner()
                self.showAlert(msg: "Address added successfully")
            }
        }
    }
    
    func updateLocation(params: [String: Any]) -> Void {
        
        let id = location?.id ?? ""
        let ref = FirebaseTables.Locations.child(id)
        ref.setValue(params){
            (error:Error?, ref:DatabaseReference) in
            if error == nil {
                
                self.removeSpinner()
                
                let alert = UIAlertController(title: "", message: "Location updated successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                                
            } else {
                
                self.removeSpinner()
                self.showAlert(msg: "Address added successfully")
            }
        }
    }
}


extension AddUpdateLocationVC: CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let loc = locations.last ?? CLLocation(latitude: 0.0000, longitude: 0.0000)
        myLocation = loc
        
        setCurrentLocation()
        self.locationManager.stopUpdatingLocation()
    }
}

extension AddUpdateLocationVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        let geocoder = GMSGeocoder()
        let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        
        geocoder.reverseGeocodeCoordinate(location.coordinate, completionHandler: {response,error in
            
            var result: GMSReverseGeocodeResult?
            var a = CLLocationCoordinate2D()
            
            if error == nil {
                result = response?.firstResult()
                
                if let coordinate = result?.coordinate {
                    a = coordinate
                }
                
                self.addressTF.text = result?.thoroughfare
                self.selectedLat = a.latitude
                self.selectedLng = a.longitude
            }
        })
    }
}
