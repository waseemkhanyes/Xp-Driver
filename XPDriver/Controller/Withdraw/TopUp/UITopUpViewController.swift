//
//  UITopUpViewController.swift
//  XPDriver
//
//  Created by Waseem  on 13/02/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit
import IQKeyboardManager

@objcMembers
class UITopUpViewController: UIViewController {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var viewEdit: UIView!
    
    //MARK: - Variables -
    
    var dicWallet: [String: Any] = [:]
    var amount: Float = 0.0
    var isTopup = true
    var activePayment: JSON {
        JSON(CodManager.currentUser().stripeCards ?? "").arrayValue.filter({$0["status"].boolValue}).first ?? JSON([:])
    }
    var strWalletId: String {
        JSON(dicWallet)["id"].stringValue
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("** wk amount: \(amount)")
        //        lblTitle.text = isTopup ? "Top UP" : "Your Cart"
        //        txtAmount.isUserInteractionEnabled = isTopup
        //        txtAmount.text = isTopup ? "" : "\(amount)"
        //        lblCardTitle.text = "Add Payment Method"
        //        viewEdit.isHidden = isTopup
        configData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        isTopup = amount >= 0.0
        configData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func configData() {
        let activePayment = activePayment
        
        lblTitle?.text = isTopup ? "Top UP" : "Your Cart"
        txtAmount?.isUserInteractionEnabled = isTopup
        if amount < 0.0 {
            txtAmount?.text = isTopup ? "" : "\(amount * -1)"
        } else {
            txtAmount?.text = isTopup ? "" : "\(amount)"
        }
        
        
        if activePayment.isEmpty {
            lblCardTitle?.text = "Add Payment Method"
            viewEdit?.isHidden = true
        } else {
            lblCardTitle?.text = activePayment["last4"].stringValue
            viewEdit?.isHidden = false
        }
    }
    
    //MARK: - IBAction -
    
    @IBAction func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickEdit() {
        if activePayment.isEmpty {
            let vc = UIAddPaymentMethodViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UICardsListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickConfirm() {
        IQKeyboardManager.shared().resignFirstResponder()
        
        guard let text = txtAmount.text, !text.isEmpty else { return }
        onClickPay(amount: Double(text) ?? 0.0)
    }
    
    //MARK: - Api Calls -
    
    func onClickPay(amount: Double) {
        self.showHud()
        let params: [String: Any] = [
            "command"   :   "topUpDriverWallet",
            "user_id"   :   CodManager.currentUser().userId ?? "",
            "amount"    :   amount,
            "wallet_id" :   strWalletId,
            "app_id"    :   "9",
        ]
        
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
//                        CodManager.fetchProfileDetail {
                            self.onClickBack()
//                        }
                    } else {
                        self.showAlert(message: json["msg"].stringValue)
                    }
                }
            }
    }
    
}
