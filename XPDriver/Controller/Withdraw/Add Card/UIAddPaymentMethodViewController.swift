//
//  UIAddPaymentMethodViewController.swift
//  XPDriver
//
//  Created by Waseem  on 13/02/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit
import Stripe
import IQKeyboardManager

class UIAddPaymentMethodViewController: UIViewController {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var viewCardBack: UIView!
    @IBOutlet weak var txtCard: SZTextField!
    @IBOutlet weak var txtCVC: SZTextField!
    @IBOutlet weak var txtExpiry: SZTextField!
    
    //MARK: - Variables -
    
    var selectedCurrency: UserCurrency {
        CodManager.selectedCurrency()
    }
    var userId: String {
        CodManager.currentUser().userId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        txtCard.text = "4242424242424242"
        ////        txtCard.text = "4000056655665556"
        //        txtExpiry.text = "1/2025"
        //        txtCVC.text = "321"
        
        let key1 = CodManager.getStripeKey()
        print("** wk key1: \(key1)")
        
        //         it's for live mode
        StripeAPI.defaultPublishableKey = key1
        
        //        // it's for test mode
        //        StripeAPI.defaultPublishableKey = "pk_test_YsTMWo7ZLJX3K6QZYujQ0BA3"
        viewCardBack.setShadowToView(cornerRadius: 3, shadowRadius: 3.0, shadowOpacity: 0.1, shadowColor: .black, shadowOffset: CGSize(width: 0, height: 4))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func saveCard() {
        IQKeyboardManager.shared().resignFirstResponder()
        
        let cardParams = STPCardParams()
        let expDate = self.txtExpiry.text?.components(separatedBy: "/") //"2025/12" //self.expirationDateTextField.text?.components(separatedBy: "/")
        print("** wk expDate: \(expDate)")
        cardParams.number = String(txtCard.text ?? "")
        cardParams.expMonth = UInt(Int(expDate?[0] ?? "") ?? 0) //12//Int(expDate?[0] ?? "") ?? 0
        cardParams.expYear = UInt(Int(expDate?[1] ?? "") ?? 0) //2025//
        cardParams.cvc = String(txtCVC.text ?? "")
        self.showHud()
        STPAPIClient.shared.createToken(withCard: cardParams) { (token, error) in
            self.hideHud()
            if token == nil || error != nil {
                print("** wk card error: \(error?.localizedDescription ?? "")")
                self.showAlert(message: error?.localizedDescription ?? "")
            }
            if let card = token?.card {
                let brandName = STPCard.string(from: card.brand)
                print("** wk Card Info %@,%@,%@,%@", card.last4, brandName, String(card.expYear), String(card.expMonth))
            }
            NSLog("** wk token.tokenId %@", token?.tokenId ?? "")
            self.postDebitCardToken(token)
            
        }
    }
    
    func postDebitCardToken(_ token: STPToken?) {
        guard let token = token, let card = token.card else { return }
        
        let brandName = STPCard.string(from: card.brand)
        print("** wk Card Info %@,%@,%@,%@", card.last4, brandName, String(card.expYear), String(card.expMonth))
        
        var params = [String: Any]()
        params["stripe_token"] = token.tokenId
        params["brand"] = STPCard.string(from: card.brand)
        params["last4"] = card.last4
        params["user_currency"] = self.selectedCurrency.name
        params["command"] = "register_stripe"
        params["app_id"] = 9
        params["token"] = ""
        params["user_id"] = userId
        params["is_sandbox"] = 1
        self.codPaymentConfirmation(params: params)
    }
    
    
    //MARK: - IBAction -
    
    @IBAction func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickProceed() {
        saveCard()
    }
    
    //MARK: - Api Calls -
    
    func codPaymentConfirmation(params: [String: Any]) {
        self.showHud()
        print("** wk params: \(params)")
        AF.request("https://www.xpeats.com/api/index.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
            .responseJSON1 { response in
                self.hideHud()
                if let error = response.error {
                    print("** wk failure 1: \(error)")
                    self.showAlert(message: error.localizedDescription)
                } else if let json = response.value {
                    print("** wk json: \(json)")
                    if json["success"].boolValue {
                        CodManager.fetchProfileDetail {
                            self.onClickBack()
                        }
                    } else {
                        self.showAlert(message: json["msg"].stringValue)
                    }
                }
            }
    }
    
}
