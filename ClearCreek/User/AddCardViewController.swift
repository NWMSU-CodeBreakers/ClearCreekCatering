//
//  AddCardViewController.swift
//  ClearCreek
//
//  Created by Student on 03/02/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct CardTypeModel {
    
    var name: String = ""
    
    init(na: String){
        self.name = na
    }
    
    init() {}
}



class AddCardViewController: UIViewController {
    func authenticationPresentingViewController() -> UIViewController {
        
        return self
    }
    
    @IBOutlet var cashBtn: UIButton!
    @IBOutlet var payBtn: UIButton!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var numberTF: UITextField!
    @IBOutlet weak var expiryTF: UITextField!
    @IBOutlet var cvcTF: UITextField!
    
    var orderID = "0"
    var orderItems: [CartInfo] = []
    var total = 0.0
    var paymentIntentClientSecret: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Payment Options"
        
        setDesign()
        
        payBtn.setTitle(String(format: "Pay By Card (%@%0.2f)", priceUnit, total), for: .normal)
        cashBtn.setTitle(String(format: "Pay By Cash (%@%0.2f)", priceUnit, total), for: .normal)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setDesign() -> Void {
        
        contentView.RoundCorners(radius: 8)
        contentView.backgroundColor = .white
    }
    
    @IBAction func addCardBtnClicked(_ sender: Any) {
        
        self.moveToStatus()
    }
    
    func moveToStatus() -> Void {
        
        self.showSpinner(onView: self.view)
        self.addOrder(key: self.orderID)
    }
    
    func addOrder(key: String) -> Void {
        
        let array = NSMutableArray()
        for item in orderItems {
            
            let dict = ["id": item.id ?? "",
                        "name": item.name ?? "",
                        "comment": item.comment ?? "",
                        "price": item.price,
                        "quantity": item.quantity,
                        "image": item.image ?? "",
                        "toppings": item.toppings ?? "",
                        "variant": item.variant ?? ""] as [String : Any]
            
            array.add(dict)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: Date())
        
        let uuid = UUID().uuidString
        let params = ["order_id": uuid,
                      "order_items": array,
                      "order_status": 0,
                      "payment_method": "1",
                      "payment_method_name": "Card",
                      "tax_amount": 0.0,
                      "total_amount": total,
                      "date": dateStr,
                      "user_id": Auth.auth().currentUser?.uid ?? ""] as [String : Any]
        
        FirebaseTables.Orders.childByAutoId().setValue(params){
            (error:Error?, ref:DatabaseReference) in
            if error == nil {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "statusViewController") as! PaymentStatusViewController
                obj.items = self.orderItems
                self.navigationController!.pushViewController(obj, animated: true)
                
            } else {
                
                self.showAlert(msg: "Error in saving user")
            }
        }
    }
    
    @IBAction func cashBtnClicked(_ sender: Any) {
        
        self.moveToStatus()
        
    }
}
