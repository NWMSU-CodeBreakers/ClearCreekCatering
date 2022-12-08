//
//  LoginViewController.swift
//  ClearCreek
//
//  Created by Student on 02/09/2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    var loginAs = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if loginAs == "admin" {
            
            forgotBtn.isHidden = true
            guestBtn.isHidden = true
            registerBtn.isHidden = true
        }
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        if emailTF.isEmpty {

            self.showAlert(msg: "Please enter email")

        }else if passwordTF.isEmpty {

            self.showAlert(msg: "Please enter password")

        }else{

            self.showSpinner(onView: self.view)
            
            if loginAs == "admin" {
                
                self.loginAsAdmin()
            }else {
                
                self.loginAsUser()
            }
        }
    }
    
    func loginAsAdmin() -> Void {
        
        FirebaseTables.Admin.observe(.value) { snapshot in
            if snapshot.childrenCount == 0 {
                
                self.removeSpinner()
                self.showAlert(msg: "Invalid email or password")
                
            }else{
                
                var i = 0
                
                for child in snapshot.children {
                    
                    i += 1
                    let snap = child as! DataSnapshot
                    let dic = snap.value as? NSDictionary ?? NSDictionary()
                    
                    let email = dic["email"] as? String ?? ""
                    let pass = dic["password"] as? String ?? ""
                    
                    if email.lowercased() == self.emailTF.text?.lowercased() && pass == self.passwordTF.text!{
                        
                        self.removeSpinner()
                        
                        UserDefaults.standard.setValue(true, forKey: "LoggedIn")
                        
                        let storyBoard = UIStoryboard(name: "Admin", bundle: nil)
                        let obj = storyBoard.instantiateViewController(withIdentifier: "SelectOptionVC") as! SelectOptionVC
                        self.navigationController!.pushViewController(obj, animated: true)
                        return
                        
                    }
                    
                    if i == snapshot.childrenCount {
                        
                        self.removeSpinner()
                        self.showAlert(msg: "Invalid email or password")
                    }
                }
            }
        }
    }
    
    func loginAsUser() -> Void {
        
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            print(strongSelf)
            
            self?.removeSpinner()
            if error != nil {
                
                self?.showAlert(msg: error?.localizedDescription ?? "Error")
            }else{
                
                self?.navigationController?.navigationBar.isHidden = true
                
                let obj = self?.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
                self?.navigationController!.pushViewController(obj, animated: true)
            }
        }
    }
    
    @IBAction func forgotBtnClicked(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    @IBAction func register(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    
    @IBAction func guestBtnClicked(_ sender: Any) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
        self.navigationController!.pushViewController(obj, animated: true)
        
    }
    
}
