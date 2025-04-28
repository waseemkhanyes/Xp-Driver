//
//  ExtensionUIViewController.swift
//  XPDriver
//
//  Created by Waseem  on 27/03/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation

extension UIViewController {
    
    @objc
    func showAlert(title: String = "XP Driver", message: String, first: String = "OK", second: String = "CANCEL", shouldTwo: Bool = false, handler: (()->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if shouldTwo {
            alert.addAction(UIAlertAction(title: second, style: UIAlertAction.Style.default, handler: nil))
        }
        
        alert.addAction(UIAlertAction(title: first, style: UIAlertAction.Style.default) { action in
            handler?()
        })
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

