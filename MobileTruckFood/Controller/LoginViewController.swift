//
//  LoginViewController.swift
//  MobileTruckFood
//
//  Created by Student on 02/09/2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @IBAction func register(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController!.pushViewController(obj, animated: true)
    }
}
