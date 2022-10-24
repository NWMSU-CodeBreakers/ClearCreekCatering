//
//  MyProfileViewController.swift
//  MobileTruckFood
//
//  Created by Student on 28/09/2022.
//

import UIKit
import FirebaseAuth

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordLbl: UILabel!
    
    @IBOutlet weak var logoutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Profile"
        self.tabBarController?.tabBar.isHidden = true
        nameView.RoundCorners(radius: 8)
        emailView.RoundCorners(radius: 8)
        passwordView.RoundCorners(radius: 8)
        logoutView.RoundCorners(radius: 8)
        
        nameLbl.text = Auth.auth().currentUser?.displayName ?? ""
        emailLbl.text = Auth.auth().currentUser?.email ?? ""
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            do {
                
                try Auth.auth().signOut()
            } catch {}
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
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
}
