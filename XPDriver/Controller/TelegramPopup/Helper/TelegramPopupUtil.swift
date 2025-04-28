//
//  TelegramPopupUtil.swift
//  XPDriver
//
//  Created by Waseem  on 14/11/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation
import UIKit

@objc class TelegramPopupUtil: NSObject {
    @objc static func saveDontShowTelegramAgainPopup() {
        guard let userId = CodManager.currentUser().userId else { return }
        UserDefaults.standard.set("yes", forKey: "dontShowTelegram/\(userId)")
    }
    
    @objc static func checkDontShowTelegramPopup() -> Bool {
        guard let userId = CodManager.currentUser().userId else { return false }
        
        guard let dontShowPopup = UserDefaults.standard.string(forKey: "dontShowTelegram/\(userId)"), !dontShowPopup.isEmpty else {
            return false
        }
        
        print("wk Retrieved domain from cache: \(dontShowPopup)")
        return dontShowPopup == "yes" ? true : false
    }
}

