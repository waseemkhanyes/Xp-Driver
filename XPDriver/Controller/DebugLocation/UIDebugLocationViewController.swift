//
//  UIDebugLocationViewController.swift
//  XPDriver
//
//  Created by Waseem  on 13/09/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UIDebugLocationViewController: UIViewController {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var txtLati: UITextField!
    @IBOutlet weak var txtLongi: UITextField!
    @IBOutlet weak var switchButton: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        txtLati.text = "\(CustomLocation.lati)"
        txtLongi.text = "\(CustomLocation.longi)"
        switchButton.isOn = CustomLocation.isActive
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Custom Location"
    }

    //MARK: - IBAction -
    
    @IBAction func onClickBack() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func onClickSave() {
        CustomLocation.saveCustomLocation(lat: txtLati.text ?? "", long: txtLongi.text ?? "", active: switchButton.isOn)
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

}
