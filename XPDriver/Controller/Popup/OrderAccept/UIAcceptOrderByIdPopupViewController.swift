//
//  UIAcceptOrderByIdPopupViewController.swift
//  XPDriver
//
//  Created by Waseem  on 29/08/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit
import IQKeyboardManager

@objcMembers
class UIAcceptOrderByIdPopupViewController: UIViewController {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var txtOrder: UITextField!
    
    //MARK: - Variables -
    
    var handlerSuccess: ((String)->())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        txtOrder.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        txtOrder.becomeFirstResponder()
    }


    //MARK: - IBAction -
    
    @IBAction func onClickCross() {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickAccept() {
        IQKeyboardManager.shared().resignFirstResponder()
        
        guard let orderId = txtOrder.text, !orderId.isEmpty else {
            self.showAlert(message: "Please enter orderId.")
            return
        }
        
        self.showAlert(message: "Are you sure it's #\(orderId)", first: "YES", second: "CANCEL", shouldTwo: true) {
            self.dismiss(animated: true)
            self.handlerSuccess?(orderId)
        }
    }

}
