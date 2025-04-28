//
//  UICodCashDetailPopupViewController.swift
//  XPDriver
//
//  Created by Waseem  on 31/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

@objcMembers
class UICodCashDetailPopupViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
//    var handler: (()->())? = nil
    var handler: (() -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - IBAction -
    
    @IBAction func onClickPayNow() {
        self.dismiss(animated: true)
        self.handler?()
    }
    
    @IBAction func onClickBack() {
        self.dismiss(animated: true)
    }

}
