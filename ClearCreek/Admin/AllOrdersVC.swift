//
//  AllOrdersVC.swift
//  ClearCreek
//
//  Created by Ali Sher on 04/12/2022.
//

import UIKit
import FirebaseDatabase

class AllOrdersVC: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    var orderList: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Orders"
        self.getOrders()
    }
    
    func getOrders() -> Void {
        
        
        FirebaseTables.Orders.observe(.value) { snapshot in
            
            var orders: [Order] = []
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dic = snap.value as? NSDictionary ?? NSDictionary()
                
                var dict = NSMutableDictionary()
                dict = dic.mutableCopy() as! NSMutableDictionary
                
                var order = Order()
                
                order.key = snap.key
                order.order_id = dict["order_id"] as? String ?? ""
                order.order_status = dict["order_status"] as? Int ?? 0
                order.payment_method = dict["payment_method"] as? String ?? ""
                order.payment_method_name = dict["payment_method_name"] as? String ?? ""
                order.tax_amount = dict["tax_amount"] as? Double ?? 0
                order.total_amount = dict["total_amount"] as? Double ?? 0
                order.date = dict["date"] as? String ?? ""
                order.user_id = dict["user_id"] as? String ?? ""
                
                let items = dict["order_items"] as? NSArray ?? NSArray()
                
                var orderItems: [OrderItem] = []
                for i in 0..<items.count {
                    
                    let ittt = items[i] as? NSDictionary ?? NSDictionary()
                    
                    var item = OrderItem()
                    item.id = ittt["id"] as? String ?? ""
                    item.comment = ittt["comment"] as? String ?? ""
                    item.image = ittt["image"] as? String ?? ""
                    item.name = ittt["name"] as? String ?? ""
                    item.price = ittt["price"] as? Double ?? 0.0
                    item.quantity = ittt["quantity"] as? Int ?? 1
                    item.toppings = ittt["toppings"] as? String ?? ""
                    item.variant = ittt["variant"] as? String ?? ""
                    
                    orderItems.append(item)
                }
                
                order.order_items = orderItems
                orders.append(order)
            }
            
            self.orderList = orders
            self.ordersTableView.reloadData()
        }
    }
}

extension AllOrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath) as!
        OrderTableViewCell
        
        let order = orderList[indexPath.row]
        let date_Str = order.date ?? ""
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formater.date(from: date_Str)
        formater.dateFormat = "yyyy-MM-dd hh:mm a"
        cell.dateLBL.text = formater.string(from: date ?? Date())
        
        cell.priceLBL.text = String(format: "%@%0.2f", priceUnit, order.total_amount ?? 0.0)
        
        let items = order.order_items
        var str = ""
        for i in 0..<(items?.count ?? 0) {
            
            let item = items?[i]
            str = "\(str)\(item?.name ?? ""),\n"
        }
        
        str.removeLast()
        str.removeLast()
        
        cell.itemsLBL.text = str
        cell.contantView.RoundCorners(radius: 8)
        
        let status = order.order_status ?? 0
        if status == 0 {
            
            cell.statusLbl.text = "Pending"
            cell.statusLbl.textColor = UIColor(named: "PrimaryColor1")
        }else if status == 1 {
            
            cell.statusLbl.text = "Completed"
            cell.statusLbl.textColor = .green
        }else if status == 2 {
            
            cell.statusLbl.text = "Cancelled"
            cell.statusLbl.textColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        
        VC.order = orderList[indexPath.row]
        
        self.navigationController!.pushViewController(VC, animated: true)
    }
}
