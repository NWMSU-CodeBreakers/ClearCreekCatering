//
//  PaymentStatusViewController.swift
//  ClearCreek
//
//  Created by Student on 26/09/2022.
//

import UIKit

class PaymentStatusViewController: UIViewController {
    
    var items: [CartInfo] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Payment"
        self.navigationItem.hidesBackButton = true
        
        self.removeFromCart()
    }
    
    func removeFromCart() -> Void {
        
        for item in items {
            
            self.context.delete(item)
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func home(_ sender: Any) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
        self.navigationController!.pushViewController(obj, animated: true)
    }
}
