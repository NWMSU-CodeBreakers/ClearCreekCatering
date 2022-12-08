//
//  MenuViewController.swift
//  ClearCreek
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
        self.getCategories {
            
            for i in 0..<self.menuList.count {
                
                self.getCategoryProducts(id: self.menuList[i].id ?? 1) { pro in
                    
                    self.menuList[i].products = pro
                    
                    self.menusTableView.reloadData()
                }
            } 
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getCategories(completion: @escaping () -> Void) {
        
        FirebaseTables.Categries.observe(.value) { snapshot in
            
            self.menuList.removeAll()
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var dict = NSMutableDictionary()
                dict = dic.mutableCopy() as! NSMutableDictionary
                
                var cat = Category()
                
                cat.id = dict["id"] as? Int ?? 0
                cat.name = dict["name"] as? String ?? ""
                
                self.menuList.append(cat)
            }
            
            completion()
        }
    }
    
    func getCategoryProducts(id: Int, completion: @escaping (_ pro: [ProductModel]) -> Void) {
        
        let ref = FirebaseTables.Categries.child("\(id - 1)").child("products")
        
        ref.observe(.value) { snapshot in
            
            var products: [ProductModel] = []
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var dict = NSMutableDictionary()
                dict = dic.mutableCopy() as! NSMutableDictionary
                
                var model = ProductModel()
                model.key = snap.key
                model.image = dict["image"] as? String ?? ""
                model.id = dict["id"] as? String ?? ""
                model.name = dict["name"] as? String ?? ""
                model.price =  dict["price"] as? Double ?? 0.0
                model.perToppingPrice =  dict["perToppingPrice"] as? Double ?? 0.0
                model.bread = dict["bread"] as? String ?? ""
                model.toppings = dict["topping"] as? [String] ?? []
                
                var productVariants: [VariantModel] = []
                
                let variants = dict["variants"] as? NSArray ?? NSArray()
                for i in 0..<variants.count {
                    
                    let v = variants[i] as? NSDictionary ?? NSDictionary()
                    var model = VariantModel()
                    
                    model.price = v["price"] as? Double ?? 0.0
                    model.name = v["name"] as? String ?? ""
                    
                    productVariants.append(model)
                }
                
                model.variants = productVariants
                
                products.append(model)
            }
            
            completion(products)
        }
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.menuList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return menuList[section].name
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
