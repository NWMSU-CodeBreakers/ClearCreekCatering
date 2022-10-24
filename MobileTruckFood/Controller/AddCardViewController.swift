//
//  AddCardViewController.swift
//  MobileTruckFood
//
//  Created by Student on 03/02/2022.
//

import UIKit
import Caishen
import BKMoneyKit
import Stripe
import FirebaseAuth
import FirebaseDatabase

struct CardTypeModel {
    
    var name: String = ""
    
    init(na: String){
        self.name = na
    }
    
    init() {}
}



class AddCardViewController: UIViewController, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        
        return self
    }
    
    @IBOutlet var payBtn: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var cardsCollectionView: UICollectionView!
    
    @IBOutlet var numberTF: NumberInputTextField!
    @IBOutlet weak var expiryTF: BKCardExpiryField!
    @IBOutlet var cvcTF: UITextField!
    
    
    var cardTypes = [CardTypeModel]()
    var cellWidth: CGFloat = 40.0
    var cellSpacing: CGFloat = 12.0
    var cellsInSection = 5
    var card = ""
    var orderID = "0"
    var orderItems: [CartInfo] = []
    var total = 0.0
    var paymentIntentClientSecret: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Payment Options"
        
        numberTF.cardNumberSeparator = " "
        numberTF.invalidInputColor = .red
        numberTF.numberInputTextFieldDelegate = self
        
        setDesign()
        cardsCollectionView.backgroundColor = .clear
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        
        payBtn.setTitle(String(format: "Pay %@%0.2f", priceUnit, total), for: .normal)
        self.tabBarController?.tabBar.isHidden = true
        
        self.gerOrderKEy { id in
            self.orderID = id
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        print(expiryTF.dateComponents.month)
        print(expiryTF.dateComponents.year)
    }
    
    func setDesign() -> Void {
        
        contentView.RoundCorners(radius: 8)
        contentView.backgroundColor = .white
        
        cardTypes.append(CardTypeModel(na: "amex"))
        cardTypes.append(CardTypeModel(na: "dinersclub"))
        cardTypes.append(CardTypeModel(na: "discover"))
        cardTypes.append(CardTypeModel(na: "jcb"))
        cardTypes.append(CardTypeModel(na: "maestro"))
        cardTypes.append(CardTypeModel(na: "mastercard"))
        cardTypes.append(CardTypeModel(na: "chinaunionpay"))
        cardTypes.append(CardTypeModel(na: "visa"))
    }
    
    @IBAction func addCardBtnClicked(_ sender: Any) {
        
        self.getToken()
    }
    
    func getToken(){
        
        let cardParams = STPCardParams()
        cardParams.number = numberTF.text!
        cardParams.expMonth = UInt(expiryTF.dateComponents.month ?? 1)
        cardParams.expYear = UInt(expiryTF.dateComponents.year ?? 2000)
        cardParams.cvc = cvcTF.text!
        //self.showSpinner(onView: self.view)
        STPAPIClient.shared.createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let _ = token, error == nil else {
                // Present error to user...
                
                //self.removeSpinner()
                return
            }
            self.paymentIntentClientSecret = token?.tokenId ?? ""
            self.pay()
        }
    }
    
    func pay() -> Void {
        
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return;
        }
        // Collect card details
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = numberTF.text!
        cardParams.expMonth = UInt(exactly: expiryTF.dateComponents.month ?? 1) as NSNumber?
        cardParams.expYear = UInt(expiryTF.dateComponents.year ?? 2000) as NSNumber?
        cardParams.cvc = cvcTF.text!
        
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        //self.showSpinner(onView: self.view)
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            switch (status) {
            case .failed:
                
                self.moveToStatus()
                break
            case .canceled:
                
                break
            case .succeeded:
                
                self.moveToStatus()
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
    func gerOrderKEy(completion:@escaping(String) -> Void) {
        
        var id = "0"
        FirebaseTables.Orders.observe(.value) { snapshot in
            var i = 0
            for child in snapshot.children {
                
                i += 1
                let snap = child as! DataSnapshot
                let key = snap.key
                var a = Int(key) ?? 0
                
                if i == snapshot.childrenCount {
                    
                    a += 1
                    id = String(a)
                }
            }
            
            completion(id)
        }
    }
    
    func moveToStatus() -> Void {
        
        self.showSpinner(onView: self.view)
        self.addOrder(key: self.orderID)
    }
    
    func addOrder(key: String) -> Void {
        
        let array = NSMutableArray()
        for item in orderItems {
            
            let dict = ["id": item.id,
                        "name": item.name ?? "",
                        "comment": item.comment ?? "",
                        "price": item.price,
                        "quantity": item.quantity,
                        "image": item.image ?? "",
                        "toppings": item.toppings ?? "",
                        "variant": item.variant ?? ""] as [String : Any]
            
            array.add(dict)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: Date())
        
        let uuid = UUID().uuidString
        let params = ["order_id": uuid,
                      "order_items": array,
                      "payment_method": "1",
                      "payment_method_name": "Card",
                      "tax_amount": 0.0,
                      "total_amount": total,
                      "date": dateStr,
                      "user_id": Auth.auth().currentUser?.uid ?? ""] as [String : Any]
        
        FirebaseTables.Orders.child(key).setValue(params){
            (error:Error?, ref:DatabaseReference) in
            if error == nil {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "statusViewController") as! PaymentStatusViewController
                obj.items = self.orderItems
                self.navigationController!.pushViewController(obj, animated: true)
                
            } else {
                
                self.showAlert(msg: "Error in saving user")
            }
        }
        
    }
    
}

extension AddCardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = collectionView.numberOfItems(inSection: section)
        let totalCellWidth = cellWidth * CGFloat(cellCount)
        let totalSpacingWidth = cellSpacing * CGFloat(cellCount - 1)
        
        let inset = (collectionView.frame.width - totalCellWidth - totalSpacingWidth) / 2
        
        return inset > 0
        ? UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        : UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            
            return 5
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : CardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! CardCollectionViewCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        var model = CardTypeModel()
        if indexPath.section == 0 {
            
            model = cardTypes[indexPath.item]
        }else{
            
            model = cardTypes[cellsInSection + indexPath.item]
        }
        
        cell.imgView.image = UIImage(named: "\(model.name).png")
        cell.imgView.alpha = 0.5
        let ss = card.replacingOccurrences(of: " ", with: "").lowercased()
        if model.name.lowercased() == ss {
            cell.imgView.alpha = 1.0
        }
        return cell
    }
}


extension AddCardViewController: NumberInputTextFieldDelegate {
    
    func numberInputTextFieldDidComplete(_ numberInputTextField: NumberInputTextField) {}
    
    func numberInputTextFieldDidChangeText(_ numberInputTextField: NumberInputTextField) {
        
        let type = numberInputTextField.cardTypeRegister.cardType(for: numberTF.cardNumber)
        card = type.name
        cardsCollectionView.reloadData()
    }
    
    func textField(_ textField: UITextField, didEnterPartiallyValidInfo: String) {}
    
    func textField(_ textField: UITextField, didEnterOverflowInfo overFlowDigits: String) {}
}


