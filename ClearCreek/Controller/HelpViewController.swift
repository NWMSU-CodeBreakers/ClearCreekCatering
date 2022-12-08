//
//  HelpViewController.swift
//  ClearCreek
//
//  Created by Student on 28/09/2022.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneLbl: UILabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Help Center"
        phoneView.RoundCorners(radius: 8)
        emailView.RoundCorners(radius: 8)
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
