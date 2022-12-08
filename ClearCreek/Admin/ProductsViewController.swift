//
//  ProductsViewController.swift
//  AdminApp
//
//  Created by Student on 04/11/2022.
//

import UIKit
import SDWebImage
import FirebaseDatabase

class ProductsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategoryID = ""
    var selectedCategory: Category? = nil
    var products: [ProductModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Products"
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewBtnClicked))
        navigationItem.rightBarButtonItems = [add]
        
        self.getProductList()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                
                // Create the AlertController and add its actions like button in ActionSheet
                let actionSheetController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)

                let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                    print("Cancel")
                }
                actionSheetController.addAction(cancelActionButton)

                let saveActionButton = UIAlertAction(title: "Edit", style: .default) { action -> Void in
                    
                    self.editClicked(index: indexPath.row)
                }
                actionSheetController.addAction(saveActionButton)

                let deleteActionButton = UIAlertAction(title: "Delete", style: .destructive) { action -> Void in
                    
                    self.deleteBtn(index: indexPath.row)
                }
                actionSheetController.addAction(deleteActionButton)
                self.present(actionSheetController, animated: true, completion: nil)
                
            }
        }
    }
    
    func editClicked(index: Int) -> Void {
        
        let product = products[index]
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        
        VC.selectedCategory = selectedCategory
        VC.product = product
        VC.selectedCategoryID = self.selectedCategoryID
        
        self.navigationController!.pushViewController(VC, animated: true)
        
    }
    
    func deleteClicked(index: Int) -> Void {
        
        let product = products[index]
        let id = product.key ?? ""
        let ref = FirebaseTables.Categries.child(selectedCategoryID).child("products").child(id)
        
        self.showSpinner(onView: self.view)
        ref.removeValue { (error, ref) in
            
            self.removeSpinner()
            if error != nil {
                
                self.showAlert(msg: "Something went wrong")
                
            }else{
                
                self.showAlert(msg: "Category deleted successfully")
                
            }
        }
        
    }
    
    
    func getProductList() -> Void {
        
        let id = selectedCategory?.id ?? 1
        let ref = FirebaseTables.Categries.child("\(id - 1)").child("products")
        
        ref.observe(.value) { snapshot in
            
            self.products.removeAll()
            
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
                
                self.products.append(model)
            }
            
            self.tableView.reloadData()
        }
    }
    
    @objc func addNewBtnClicked() -> Void {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        
        VC.selectedCategory = self.selectedCategory
        VC.selectedCategoryID = self.selectedCategoryID
        
        self.navigationController!.pushViewController(VC, animated: true)
    }
    
    func deleteBtn(index: Int) -> Void {
        
        let Alert = UIAlertController(title: "", message: "Are you sure you want to delete this product?", preferredStyle: UIAlertController.Style.alert)
        
        let editAction = UIAlertAction(title: "No", style: .destructive) { (action: UIAlertAction) in
            
           
        }
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { (action: UIAlertAction) in
            
            self.deleteClicked(index: index)
        }
     
        Alert.addAction(editAction)
        Alert.addAction(deleteAction)
        self.present(Alert, animated: true, completion: nil)
    }
}

extension ProductsViewController:UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("FoodTableViewCell", owner: self, options: nil)?.first as! FoodTableViewCell
        
        let product = products[indexPath.row]
        cell.contantView.layer.cornerRadius = 8
        cell.nameLbl.text = product.name
        cell.priceLbl.text = "$\(product.price ?? 0.0)"
        
        let imgURL = product.image ?? ""
        let url = URL(string: imgURL)
        cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
    }
}
