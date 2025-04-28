//
//  UISubmitedSuccessfullyPopupViewController.swift
//  XPDriver
//
//  Created by Waseem  on 31/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UISubmitedSuccessfullyPopupViewController: UIViewController {
    
    @IBOutlet weak var lblDetail: UILabel!
    
    var handler: (()->())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblDetail.text = ""
//        lblDetail.text = "Your reason has been submitted successfully.  Support will message you with a response."
    }


    //MARK: - IBAction -
    
    @IBAction func onClickCross() {
        handler?()
        self.dismiss(animated: true)
    }

}
