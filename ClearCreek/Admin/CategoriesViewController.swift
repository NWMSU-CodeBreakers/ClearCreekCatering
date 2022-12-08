//
//  CategoriesViewController.swift
//  RestaurantApp
//
//  Created by Student on 05/12/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseCore

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var dataTableView: UITableView!
    
    var categoriesList: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Categories List"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = false
        
        self.getCategories()
    }
    
    func getCategories () -> Void {
        
        FirebaseTables.Categries.observe(.value) { snapshot in
            
            self.categoriesList.removeAll()
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var dict = NSMutableDictionary()
                dict = dic.mutableCopy() as! NSMutableDictionary
                
                var cat = Category()
                
                cat.id = dict["id"] as? Int ?? 0
                cat.name = dict["name"] as? String ?? ""
                
                self.categoriesList.append(cat)
            }
            
            self.dataTableView.reloadData()
        }
    }
}

extension CategoriesViewController:UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CategoryTableViewCell", owner: self, options: nil)?.first as! CategoryTableViewCell
        
        cell.contantView.layer.cornerRadius = 8
        cell.nameLbl.text = categoriesList[indexPath.row].name ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cat = categoriesList[indexPath.row]
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        
        VC.selectedCategory = cat
        VC.selectedCategoryID = "\(indexPath.row)"
        
        self.navigationController!.pushViewController(VC, animated: true)
        
    }
}
