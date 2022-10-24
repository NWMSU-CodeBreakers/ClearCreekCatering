//
//  Extensions.swift
//  MobileTruckFood
//
//  Created by Student on 02/09/2022.
//

import Foundation
import UIKit

extension UIView {
    
    func RoundCorners(radius: Int) -> Void {
        
        self.layer.cornerRadius = CGFloat(radius)
    }
}


//MARK: Show Spinner
var vSpinner : UIView?
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        var x = self.view.frame.size.width/2
        x -= 50
        
        var y = self.view.frame.size.height/2
        y -= 50
        
        let View1 = UIView.init(frame: CGRect(x: x, y: y, width: 100, height: 100))
        View1.backgroundColor = .black
        View1.layer.cornerRadius = 16
        
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.frame = CGRect(x: 25, y: 16, width: 50, height: 50)
        ai.color = .white
        View1.addSubview(ai)
        
        DispatchQueue.main.async {
            spinnerView.addSubview(View1)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}


extension UITextField {
    
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
    
}


extension UIViewController {
    
    func showAlert(msg: String){
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
