//
//  UITelegramPopupViewController.swift
//  XPDriver
//
//  Created by Waseem  on 14/11/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

@objc class UITelegramPopupViewController: UIViewController {
    
    @IBOutlet weak var viewSingle: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let isRequired = CodManager.currentUser().telegramRegistrationRequired
        viewSingle.isHidden = isRequired != "1"
    }

    @IBAction func onClickDontShow() {
        TelegramPopupUtil.saveDontShowTelegramAgainPopup()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickCross() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickOk() {
        if let url = URL(string: "https://t.me/xpdriver_bot"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        dismiss(animated: true, completion: nil)
    }
}
