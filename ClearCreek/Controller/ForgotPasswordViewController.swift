//
//  ForgotPasswordViewController.swift
//  ClearCreek
//
//  Created by Ali Sher on 11/10/2022.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        
        if emailTF.text == "" {
            
            self.showAlert(msg: "Please enter email")
        }else {
            
            if emailTF.text!.isValidEmail() {
                
                self.sendOTP()
            }else{
                
                self.showAlert(msg: "Please enter a valid email")
            }
        }
    }
    
    func sendOTP() -> Void {
        
        Auth.auth().sendPasswordReset(withEmail: emailTF.text!) { error in
            
            if let error = error {
                
                self.showAlert(msg: error.localizedDescription )
                return
            }
            
            self.showAlert(msg: "OTP sent to \(self.emailTF.text!)" )
        }
    }
}


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
