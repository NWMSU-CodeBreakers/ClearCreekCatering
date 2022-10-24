//
//  DetailsViewController.swift
//  MobileTruckFood
//
//  Created by Student on 13/09/2022.
//

import UIKit
import SDWebImage
import CoreML
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var nameLBL: UILabel!
    @IBOutlet var priceLBL: UILabel!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var deliveryTimeLbl: UILabel!
    @IBOutlet var detailsLbl: UILabel!
    @IBOutlet var counterView: UIView!
    @IBOutlet var counterLBL: UILabel!
    
    @IBOutlet var deliveryView: UIView!
    
    @IBOutlet var toppingsView: UIView!
    @IBOutlet var toppingsTableView: UITableView!
    @IBOutlet var toppingsViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet var variantsView: UIView!
    @IBOutlet var variantsTableView: UITableView!
    @IBOutlet var variantsViewHeightCons: NSLayoutConstraint!
    
    var product: ProductModel? = nil
    var Toppings: [String] = []
    var Variants: [VariantModel] = []
    var counter = 1
    
    var selectedToppings: [Bool] = []
    var selectedVariant = -1
    var priceOfProduct = 0.0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        self.tabBarController?.tabBar.isHidden = true
        priceLBL.text = ""
        
        counterView.RoundCorners(radius: 18)
        deliveryView.RoundCorners(radius: 20)
        
        setData()
    }
    
    func setData() -> Void {
        
        let imgURL = product?.image ?? ""
        let url = URL(string: imgURL)
        imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
        
        nameLBL.text = product?.name ?? ""
        
        Toppings = product?.toppings ?? []
        for _ in 0..<Toppings.count {
            
            selectedToppings.append(false)
        }
        
        toppingsView.isHidden = true
        if product?.toppings?.count ?? 0 > 0 {
            
            toppingsViewHeightCons.constant = CGFloat(Toppings.count * 40)
            toppingsView.isHidden = false
        }
        
        Variants = product?.variants ?? []
        variantsView.isHidden = true
        if product?.variants?.count ?? 0 > 0 {
            
            selectedVariant = 0
            variantsViewHeightCons.constant = CGFloat(Variants.count * 40)
            variantsView.isHidden = false
            variantsTableView.reloadData()
        }
        
        self.calculate()
    }
    
    
    @IBAction func minusClicked(_ sender: Any) {
        
        if counter > 1 {
            
            counter -= 1
        }
        self.setCounterValue()
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        
        counter += 1
        self.setCounterValue()
    }
    
    
    @IBAction func addToCart(_ sender: Any) {
        
        let cart = CartInfo(context: self.context)
        cart.id = Int16(product?.id ?? 0)
        cart.name = product?.name ?? ""
        cart.quantity = Int16(counter)
        cart.price = priceOfProduct
        cart.image = product?.image ?? ""
        cart.comment = ""
        
        var toppings = ""
        for i in 0..<selectedToppings.count {
            
            if selectedToppings[i] {
                
                toppings = String(format: "%@%@,", toppings, Toppings[i])
            }
        }
        
        if toppings.count > 0 {
            toppings.removeLast()
        }
        
        cart.toppings = toppings
        
        var variant = ""
        if selectedVariant > -1 {
            
            variant = Variants[selectedVariant].name ?? ""
        }
        cart.variant = variant
        
        do {
            try self.context.save()
            
            let alert = UIAlertController(title: "Alert", message: "Add to cart Successfully!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
                
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(ok)
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setCounterValue() -> Void {
        
        counterLBL.text = "\(counter)"
        self.calculate()
    }
    
    func calculate() -> Void {
        
        if Variants.count > 0 {
            
            var price = product?.price ?? 0.0
            let toppingPrice = product?.perToppingPrice ?? 0.0
            if Variants.count > 0 {
                
                price = 0.0
                price = Variants[selectedVariant].price ?? 0.0
            }
            
            for i in 0..<selectedToppings.count {
                
                if selectedToppings[i] {
                    
                    price += toppingPrice
                }
            }
            
            priceOfProduct = price
            
            price *= Double(counter)
            priceLBL.text = String(format: "%@%0.2f", priceUnit, price)
        }else{
            
            var price = product?.price ?? 0.0
            let toppingPrice = product?.perToppingPrice ?? 0.0
            
            for i in 0..<selectedToppings.count {
                
                if selectedToppings[i] {
                    
                    price += toppingPrice
                }
            }
            
            priceOfProduct = price
            
            price *= Double(counter)
            priceLBL.text = String(format: "%@%0.2f", priceUnit, price)
        }
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == toppingsTableView {
            
            return Toppings.count
        }
        
        return Variants.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == toppingsTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "topping", for: indexPath) as! ToppingTableViewCell
            
            cell.imgView.image = UIImage(named: "BoxUnChecked")
            if selectedToppings[indexPath.row] {
                
                cell.imgView.image = UIImage(named: "BoxChecked")
            }
            cell.imgView.tintColor = UIColor(named: "PrimaryColor1")
            
            cell.nameLbl.text = Toppings[indexPath.row]
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "variant", for: indexPath) as! VariantTableViewCell
        
        cell.imgView.image = UIImage(named: "RadioUnSelected")
        if selectedVariant == indexPath.row {
            
            cell.imgView.image = UIImage(named: "RadioSelected")
        }
        cell.imgView.tintColor = UIColor(named: "PrimaryColor1")
        
        cell.nameLbl.text = Variants[indexPath.row].name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == toppingsTableView {
            
            let op = selectedToppings[indexPath.row]
            selectedToppings[indexPath.row] = !op
        }else{
            
            selectedVariant = indexPath.row
        }
        
        self.calculate()
        tableView.reloadData()
    }
}

