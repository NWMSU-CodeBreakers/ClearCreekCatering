//
//  LoginAsViewController.swift
//  ClearCreek
//
//  Created by Ali Sher on 02/12/2022.
//

import UIKit

class LoginAsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func adminBtn(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        obj.loginAs = "admin"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    @IBAction func userBtn(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        obj.loginAs = "user"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
