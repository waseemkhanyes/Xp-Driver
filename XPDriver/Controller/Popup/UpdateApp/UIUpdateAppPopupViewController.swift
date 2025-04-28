//
//  UIUpdateAppPopupViewController.swift
//  XPDriver
//
//  Created by Waseem  on 22/04/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UIUpdateAppPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - IBAction -
    
    @IBAction func onClickUpdate() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1439220195") {
            UIApplication.shared.open(url)
        }
    }

}
