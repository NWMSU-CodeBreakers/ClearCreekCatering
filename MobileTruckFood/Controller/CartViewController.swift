//
//  CartViewController.swift
//  MobileTruckFood
//
//  Created by Student on 04/09/2022.
//

import UIKit
import SDWebImage

class CartViewController: UIViewController {
    
    @IBOutlet var cartTableView: UITableView!
    var selectedIndexes: [Bool] = []
    
    @IBOutlet var itemsCountLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var checkoutView: UIView!
    @IBOutlet var noRecordLbl: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cartList: [CartInfo] = []
    var TotalAmount = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.getCartList()
    }
    
    func getCartList() -> Void {
        
        do {
            cartList = try context.fetch(CartInfo.fetchRequest())
            self.checkData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkData() -> Void {
        
        for _ in 0..<cartList.count {
            
            self.selectedIndexes.append(false)
        }
        cartTableView.reloadData()
        
        noRecordLbl.isHidden = false
        if cartList.count > 0 {
            
            noRecordLbl.isHidden = true
        }
        
        self.calculateTotal()
    }
    
    @IBAction func checkoutBtnClicked(_ sender: Any) {
        
        var selectedCart: [CartInfo] = []
        for i in 0..<selectedIndexes.count {
            
            if selectedIndexes[i] {
                
                selectedCart.append(cartList[i])
            }
        }
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
        
        obj.total = TotalAmount
        obj.orderItems = selectedCart
        
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    @objc func minusBtn(sender: UIButton) -> Void {
        
        let Tag = sender.tag
        let item = cartList[Tag]
        
        var counter = item.quantity
        counter -= 1
        
        if counter == 0 {
            
            self.selectedIndexes.removeAll()
            self.context.delete(item)
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }else{
            
            item.quantity = counter
            do {
                try self.context.save()                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        self.getCartList()
    }
    
    @objc func plusBtn(sender: UIButton) -> Void {
        
        let Tag = sender.tag
        let item = cartList[Tag]
        
        var counter = item.quantity
        counter += 1
        
        if counter == 0 {
            
            self.context.delete(item)
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }else{
            
            item.quantity = counter
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        self.getCartList()
    }
    
    func calculateTotal() -> Void {
        
        var selectedCount = 0
        var total = 0.0
        
        for i in 0..<selectedIndexes.count {
            
            if selectedIndexes[i] {
                
                selectedCount += 1
                let item = cartList[i]
                var price = item.price
                let count = item.quantity
                
                price *= Double(count)
                total += price
            }
        }
        
        self.checkoutView.isHidden = true
        if selectedCount > 0 {
            
            self.checkoutView.isHidden = false
        }
        
        TotalAmount = total
        itemsCountLbl.text = "Selected Items (\(selectedCount))"
        priceLbl.text = String(format: "%@%0.2f", priceUnit, total)
    }
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cart", for: indexPath) as! CartTableViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let item = cartList[indexPath.row]
        cell.nameLBL.text = item.name
        
        let imgURL = item.image ?? ""
        let url = URL(string: imgURL)
        cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
        
        cell.counterLBL.text = "\(item.quantity)"
        
        var price = item.price
        price *= Double(item.quantity)
        cell.priceLBL.text = String(format: "%@%0.2f", priceUnit, price)
        
        cell.contantView.RoundCorners(radius: 8)
        cell.minusBtn.RoundCorners(radius: 18)
        cell.plusBtn.RoundCorners(radius: 18)
        cell.imgView.RoundCorners(radius: 35)
        cell.imgView.clipsToBounds = true
        
        cell.minusBtn.tag = indexPath.row
        cell.minusBtn.addTarget(self, action: #selector(minusBtn(sender:)), for: .touchUpInside)
        
        cell.plusBtn.tag = indexPath.row
        cell.plusBtn.addTarget(self, action: #selector(plusBtn(sender:)), for: .touchUpInside)
        
        cell.checkBtn.isUserInteractionEnabled = false
        cell.checkBtn.setImage(UIImage(named: "BoxUnChecked"), for: .normal)
        if selectedIndexes[indexPath.row] {
            
            cell.checkBtn.setImage(UIImage(named: "BoxChecked"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexes[indexPath.row] = !selectedIndexes[indexPath.row]
        tableView.reloadData()
        self.calculateTotal()
    }
}
