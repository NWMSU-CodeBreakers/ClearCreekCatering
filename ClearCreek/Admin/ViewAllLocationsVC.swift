//
//  ViewAllLocationsVC.swift
//  AdminApp
//
//  Created by Ali Sher on 28/11/2022.
//

import UIKit
import FirebaseDatabase

class ViewAllLocationsVC: UIViewController {
    
    
    @IBOutlet weak var dataTableView: UITableView!
    
    var locations: [LocationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Locations"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getLocations()
    }
    
    
    func getLocations () -> Void {
        
        FirebaseTables.Locations.observe(.value) { snapshot in
            
            self.locations.removeAll()
            
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
                self.locations.append(model)
                
            }
            
            self.dataTableView.reloadData()
        }
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        
        self.movetoLocation(loc: nil)
    }
    
    
    func deletClicked(loc: LocationModel?) -> Void {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this address?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            
            self.delete(id: loc?.id ?? "")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func delete(id: String) {
        
        FirebaseTables.Locations.child(id).removeValue { (error, ref) in
            
            if error != nil {
                
                self.showAlert(msg: "Something went wrong")
                
            }else{
                
                self.showAlert(msg: "Category deleted successfully")
                
            }
        }
    }
}


extension ViewAllLocationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let loc = locations[indexPath.row]
        
        let Alert = UIAlertController(title: "Select Option", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
            
            self.deletClicked(loc: loc)
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action: UIAlertAction) in
            
            self.movetoLocation(loc: loc)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        Alert.addAction(editAction)
        Alert.addAction(deleteAction)
        Alert.addAction(cancelAction)
        self.present(Alert, animated: true, completion: nil)
    }

    func movetoLocation(loc: LocationModel?) -> Void {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddUpdateLocationVC") as! AddUpdateLocationVC
        VC.location = loc
        self.navigationController!.pushViewController(VC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "locationCell")
        
        let loc = locations[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = loc.name
        cell.detailTextLabel?.text = loc.address
        cell.imageView?.image = UIImage(systemName: "location.circle")
        
        return cell
    }
}
