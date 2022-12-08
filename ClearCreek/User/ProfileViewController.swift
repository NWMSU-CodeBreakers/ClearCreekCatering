//
//  ProfileViewController.swift
//  ClearCreek
//
//  Created by Student on 04/09/2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameLbl: UILabel!
    let nameslist = ["My Orders", "Previous Orders", "My Profile", "Help Center"]
    let imageslist = ["Orders", "Orders", "Profile1", "Help"]
    
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = "Hello, \(Auth.auth().currentUser?.displayName ?? "")"
        
        loginBtn.isHidden = true
        if Auth.auth().currentUser == nil {
         
            nameLbl.isHidden = true
            dataTableView.isHidden = true
            loginBtn.isHidden = false
        }
        
        loginBtn.layer.cornerRadius = 8
        loginBtn.layer.borderColor = UIColor.orange.cgColor
        loginBtn.layer.borderWidth = 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath) as! ProfileTableViewCell
        
        cell.textLBL.text = nameslist[indexPath.row]
        let img = imageslist[indexPath.row]
        
        if img != "" {
            
            cell.imgView.image = UIImage(named: img)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
            obj.status = 0
            self.navigationController!.pushViewController(obj, animated: true)
            
        }else if indexPath.row == 1 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
            obj.status = 1
            self.navigationController!.pushViewController(obj, animated: true)
        }else if indexPath.row == 2 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController!.pushViewController(obj, animated: true)
        }else if indexPath.row == 3 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
}
