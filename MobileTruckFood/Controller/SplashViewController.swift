//
//  SplashViewController.swift
//  MobileTruckFood
//
//  Created by Student on 02/09/2022.
//

import UIKit
import FirebaseAuth

var priceUnit = "$"

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            if Auth.auth().currentUser != nil {
                
                self.navigationController?.navigationBar.isHidden = true
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
                self.navigationController!.pushViewController(obj, animated: true)
            }else{
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
                self.navigationController!.pushViewController(obj, animated: true)
            }
        }
    }
}

