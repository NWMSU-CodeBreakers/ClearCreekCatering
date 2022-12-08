//
//  AddProductViewController.swift
//  RestaurantApp
//
//  Created by Student on 05/12/2021.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class AddProductViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
//    @IBOutlet weak var urlTF: UITextField!
    
    @IBOutlet weak var urlTV: UITextView!
    @IBOutlet var categoryTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var breadTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var topingPriceTF: UITextField!
    
    
    @IBOutlet weak var toppingsView: UIView!
    @IBOutlet weak var toppingsTV: UITableView!
    
    @IBOutlet weak var newToppingView: UIView!
    @IBOutlet weak var toppingNameTF: UITextField!
    
    @IBOutlet weak var variantsView: UIView!
    
    @IBOutlet weak var variantsTV: UITableView!
    @IBOutlet weak var newVariantView: UIView!
    @IBOutlet weak var variantNameTF: UITextField!
    @IBOutlet weak var variantPriceTF: UITextField!
    
    @IBOutlet weak var addUpdateBtn: UIButton!
    
    var toppingsArray: [String] = []
    var VariantsArray: [[String:Any]] = [[:]]
    
    var selectedCategoryID = ""
    var selectedCategory: Category? = nil
    var product: ProductModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VariantsArray.removeAll()
        urlTV.delegate = self
        
        categoryTF.text = selectedCategory?.name ?? ""
        categoryTF.isUserInteractionEnabled = false
        
        if product != nil {
            
            self.setData()
        }
        
        self.navigationItem.title = "Add Product"
    }
    
    func setData() -> Void {
        
        let imgURL = product?.image ?? ""
        let url = URL(string: imgURL)
        imgView.sd_setImage(with: url, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
            //self.urlTF.placeholder = ""
        })
        
        let img_str = product?.image ?? ""
        if img_str != "" {
            
            //urlTF.placeholder = ""
        }
        
        urlTV.text = product?.image ?? ""
        nameTF.text = product?.name ?? ""
        breadTF.text = product?.bread ?? ""
        let price = product?.price ?? 0.0
        priceTF.text = price == 0 ? "0.0" : "\(price)"
        
        let perToppingPrice = product?.perToppingPrice ?? 0.0
        topingPriceTF.text = price == 0.0 ? "0.0" : "\(perToppingPrice)"
        
        toppingsArray = product?.toppings ?? []
        
        let arr = product?.variants ?? []
        for i in 0..<arr.count {
            
            let model = arr[i]
            
            let variant = ["name": model.name ?? "",
                           "price": model.price ?? 0.0] as [String : Any]
            
            VariantsArray.append(variant)
            
        }
        
        addUpdateBtn.setTitle("Update Product", for: .normal)
    }
    
    @IBAction func addToppingBtn(_ sender: Any) {
        
        if toppingNameTF.text == "" {
            
            showAlert(msg: "Enter topping name")
            return
        }
        
        toppingsArray.append(toppingNameTF.text!)
        
        toppingNameTF.text = ""
        toppingsTV.reloadData()
    }
    
    @IBAction func addVariantBtn(_ sender: Any) {
        
        if variantNameTF.text == "" {
            
            showAlert(msg: "Enter variant name")
            return
        }
        
        if variantPriceTF.text == "" {
            
            showAlert(msg: "Enter variant price")
            return
        }
        
        let variant = ["name": variantNameTF.text!,
                       "price": Double(variantPriceTF.text ?? "0.0") ?? 0.0] as [String : Any]
        
        VariantsArray.append(variant)
        
        variantNameTF.text = ""
        variantPriceTF.text = ""
        variantsTV.reloadData()
    }
    
    @IBAction func addProductBtn(_ sender: Any) {
        
        if product == nil {
            
            addNewProduct()
        }else{
            
            updateProduct()
        }
        
    }
    
    
    func getParams() -> [String:Any] {
        
        var params = ["bread": breadTF.text ?? "",
                      "image": urlTV.text ?? "",
                      "price": Double(priceTF.text ?? "0.0") ?? 0.0,
                      "perToppingPrice": Double(topingPriceTF.text ?? "0.0") ?? 0.0,
                      "name": nameTF.text ?? ""] as [String : Any]
        
        if product == nil {
            
            params["id"] = self.generateID()
        }
        
        if toppingsArray.count > 0 {
            
            params["toppings"] = toppingsArray
        }
        
        if VariantsArray.count > 0 {
            
            params["variants"] = VariantsArray
        }
        
        return params
    }
    
    func addNewProduct() -> Void {
        
        let params = self.getParams()
        let ref = FirebaseTables.Categries.child(selectedCategoryID).child("products")
        
        ref.childByAutoId().setValue(params){
            (error:Error?, ref:DatabaseReference) in
            if error == nil {
                
                self.removeSpinner()
                
                let alert = UIAlertController(title: "", message: "Product added successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
                
            } else {
                
                self.removeSpinner()
                self.showAlert(msg: "Something went wrong")
            }
        }
    }
    
    func updateProduct() -> Void {
        
        let params = self.getParams()
        let id = product?.key ?? ""
        let ref = FirebaseTables.Categries.child(selectedCategoryID).child("products").child(id)
        
        self.showSpinner(onView: self.view)
        ref.setValue(params){
            (error:Error?, ref:DatabaseReference) in
            if error == nil {
                
                self.removeSpinner()
                
                let alert = UIAlertController(title: "", message: "Product updated successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                                
            } else {
                
                self.removeSpinner()
                self.showAlert(msg: "something went wrong")
            }
        }
    }
    
    
    func showAlert1(msg: String) -> Void {
        
        let alert = UIAlertController(title: "appname", message: msg, preferredStyle: .alert)
            
             let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
                
                self.navigationController?.popViewController(animated: true)
                
             })
             alert.addAction(ok)
             DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
        })
    }
    
    @IBAction func pasteBtn(_ sender: Any) {
        
        urlTV.text = UIPasteboard.general.string
    }
    
    
    @objc func deleteTopping(sender: UIButton) -> Void {
        
        toppingsArray.remove(at: sender.tag)
        self.toppingsTV.reloadData()
    }
    
    @objc func deleteVariant(sender: UIButton) -> Void {
        
        self.VariantsArray.remove(at: sender.tag)
        self.variantsTV.reloadData()
    }
}


extension AddProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == toppingsTV {
            
            return toppingsArray.count
        }
        
        return VariantsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == toppingsTV {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "topping", for: indexPath) as! ToppingCell
            
            cell.nameLbl.text = toppingsArray[indexPath.row]
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteTopping(sender:)), for: .touchUpInside)
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "variant", for: indexPath) as! VariantCell
        
        let variant = VariantsArray[indexPath.row]
        
        cell.nameLbl?.text = variant["name"] as? String ?? ""
        cell.priceLbl?.text = String(format: "$%0.2f", variant["price"] as? Double ?? 0.0)
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteVariant(sender:)), for: .touchUpInside)
        return cell
    }
    
    
}

extension UIViewController {
    
    func generateID()->String{
        
        let random = Int.random(in: 0..<98898981)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        
        return "\(components.year!)\(components.month!)\(components.day!)\(components.hour!)\(components.minute!)\(components.second!)\(random)"
    }
}

extension AddProductViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let paste = UIPasteboard.general.string, text == paste {
           print("paste")
        } else {
           print("normal typing")
        }
        return true
    }
}
