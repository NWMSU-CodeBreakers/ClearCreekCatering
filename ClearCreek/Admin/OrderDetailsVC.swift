//
//  OrderDetailsVC.swift
//  ClearCreek
//
//  Created by Ali Sher on 05/12/2022.
//

import UIKit

class OrderDetailsVC: UIViewController {

    @IBOutlet weak var dataTableView: myTableView!
    @IBOutlet weak var orderIdLbl: UILabel!
    
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var btnsView: UIView!
    var order: Order?
    var orderItems: [OrderItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Order Details"
        orderItems = order?.order_items ?? []
        self.calculateTotal()
        
        btnsView.isHidden = true
        if order?.order_status == 0 {
            
            btnsView.isHidden = false
        }
    }
    
    func calculateTotal() -> Void {
        
        var total = 0.0
        
        for i in 0..<orderItems.count {
            
            let item = orderItems[i]
            var price = item.price ?? 0.0
            let count = item.quantity ?? 1
            
            price *= Double(count)
            total += price
        }
        
        let tax = order?.tax_amount ?? 0.0
        taxLbl.text = String(format: "%@%0.2f", priceUnit, tax)
        subTotalLbl.text = String(format: "%@%0.2f", priceUnit, total)
        totalLbl.text = String(format: "%@%0.2f", priceUnit, (total + tax))
        
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to cancel this order?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            
            self.cancel()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancel() -> Void {
        
        let key = order?.key ?? ""
        self.showSpinner(onView: self.view)
        FirebaseTables.Orders.child(key).updateChildValues(["order_status": 2]) { (error, ref) in
            
            self.removeSpinner()
            if error != nil {
                
                self.showAlert(msg: "Something went wrong")
            }else{
                
                let alert = UIAlertController(title: "", message: "Order canceled successfully.", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    @IBAction func completedBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to complete this order?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            
            self.complete()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func complete() -> Void {
        
        let key = order?.key ?? ""
        self.showSpinner(onView: self.view)
        FirebaseTables.Orders.child(key).updateChildValues(["order_status": 1]) { (error, ref) in
            
            self.removeSpinner()
            if error != nil {
                
                self.showAlert(msg: "Something went wrong")
            }else{
                
                let alert = UIAlertController(title: "", message: "Order marked as completed.", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}


extension OrderDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as!
        OrderItemTableViewCell
        
        let item = orderItems[indexPath.row]
        cell.priceLbl.text = String(format: "%@%0.2f", priceUnit, item.price ?? 0.0)
        
        cell.nameLbl.text = String(format: "%dx  %@", item.quantity ?? 1, item.name ?? "")
        cell.detailsLbl.text = item.toppings ?? ""
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
