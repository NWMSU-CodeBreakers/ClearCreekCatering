//
//  SelectOptionVC.swift
//  AdminApp
//
//  Created by Ali Sher on 19/11/2022.
//

import UIKit
import FirebaseAuth

class SelectOptionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        let add = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutClicked))
        navigationItem.rightBarButtonItems = [add]
    }
    
    @objc func logoutClicked() -> Void {
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            UserDefaults.standard.setValue(false, forKey: "LoggedIn")
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let obj = storyBoard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
            self.navigationController!.pushViewController(obj, animated: true)
            
            
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "No", style: .default, handler: { action in
        })
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    @IBAction func categoriesBtnClicked(_ sender: Any) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        self.navigationController!.pushViewController(VC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func locationsBtnClicked(_ sender: Any) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllLocationsVC") as! ViewAllLocationsVC
        self.navigationController!.pushViewController(VC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func ordersBtn(_ sender: Any){
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AllOrdersVC") as! AllOrdersVC
        self.navigationController!.pushViewController(VC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
}
