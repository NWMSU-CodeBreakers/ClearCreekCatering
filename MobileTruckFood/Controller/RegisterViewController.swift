//
//  RegisterViewController.swift
//  MobileTruckFood
//
//  Created by Student on 02/09/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        if nameTF.isEmpty {
            
            self.showAlert(msg: "Please enter name")
            
        }else if emailTF.isEmpty {
            
            self.showAlert(msg: "Please enter email")
            
        }else if passwordTF.isEmpty {
            
            self.showAlert(msg: "Please enter password")
            
        }else{
            
            self.showSpinner(onView: self.view)
            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { authResult, error in
              
                if error != nil {
                    
                    self.removeSpinner()
                    self.showAlert(msg: error?.localizedDescription ?? "Error in saving user")
                }else{
                    
                    let profile = authResult?.user.createProfileChangeRequest()
                    profile?.displayName = self.nameTF.text!
                    profile?.commitChanges(completion: { error in
                        if error != nil {
                            
                            self.removeSpinner()
                            self.showAlert(msg: error?.localizedDescription ?? "Error in saving user")
                        }else{
                            
                            self.loginUser()
                        }
                    })
                }
            }
        }
    }
    
    func loginUser() -> Void {
        
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            print(strongSelf)
          
            self?.removeSpinner()
            self?.navigationController?.navigationBar.isHidden = true
            
            let obj = self?.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
            self?.navigationController!.pushViewController(obj, animated: true)
        }
    }
}
