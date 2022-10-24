//
//  MenuViewController.swift
//  MobileTruckFood
//
//  Created by Student on 13/09/2022.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class MenuViewController: UIViewController {
    
    @IBOutlet var menusTableView: UITableView!
    var menuList: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        self.getCategories { name in
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getCategories(completion: @escaping (_ name: String?) -> Void) {
        
        let decoder = JSONDecoder()
        FirebaseTables.Categries.observe(.value) { snapshot in
            
            guard let data = snapshot.data else { return }
            do{
                let result = try decoder.decode([Category].self, from: data)
                print(result )
                
                self.menuList = result
                self.menusTableView.reloadData()
            }catch{
                print("errpr 2")
                print(error.localizedDescription)
            }
        }
    }
    
    func getCategoryProducts() -> Void {
        
        
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.menuList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return menuList[section].name ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuList[section].products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath) as! MenuTableViewCell
        
        let category = menuList[indexPath.section]
        let products = category.products ?? []
        let product = products[indexPath.row]
        
        cell.priceLBL.isHidden = true
        cell.nameLBL.text = product.name
        cell.detailsLBL.text = product.bread
        
        let imgURL = product.image ?? ""
        let url = URL(string: imgURL)
        cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
        
        cell.imgView.RoundCorners(radius: 50)
        cell.imgView.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        let category = menuList[indexPath.section]
        let products = category.products ?? []
        let product = products[indexPath.row]
        
        obj.product = product
        
        self.navigationController!.pushViewController(obj, animated: true)
    }
}


extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? { data?.string }
}
extension Data {
    var string: String? { String(data: self, encoding: .utf8) }
}
