//
//  BannerUtil.swift
//  XPDriver
//
//  Created by Waseem  on 23/11/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation
import NotificationBannerSwift

var APPNAME : String {
    if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
        return appName
    }
    
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
}

@objcMembers
class BannerUtil: NSObject {
    static var shared: BannerUtil = BannerUtil()
    
    @objc
    func showBannerAlerrt(type: BannerStyle = .success, message: String, onTap : (()->())? = nil) {
        showBannerAlert(type: type, title: "", message: message, duration: 3, onTap: onTap)
    }
    
    @objc
    func showBannerAlerrt(type: BannerStyle = .success, title: String = APPNAME, message: String, onTap : (()->())? = nil) {
        showBannerAlert(type: type, title: title, message: message, duration: 3, onTap: onTap)
    }
    
    @objc
    func showBannerAlerrt(type: BannerStyle = .success, messages: [String], onTap : (()->())? = nil)
    {
        showBannerAlert(type: type, title: "", messages: messages, duration: 3, onTap: onTap)
    }
    
    @objc
    func showBannerAlerrt(type: BannerStyle = .success, title: String = APPNAME, messages: [String], onTap : (()->())? = nil)
    {
        showBannerAlert(type: type, title: title, messages: messages, duration: 3, onTap: onTap)
    }
}

func showBannerAlert(type: BannerStyle = .success, title: String = APPNAME, message: String, duration: Int = 3, onTap : (()->())? = nil)
{
    NotificationBannerQueue.default.removeAll()
    let newMessage = message
//    if !message.hasPrefix("• ") {
//        newMessage = "• " + message
//    }
    
    let banner = GrowingNotificationBanner(title: title, subtitle: newMessage, style: type)
    banner.subtitleLabel?.textAlignment = .center
    banner.subtitleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    banner.onTap = onTap
    
    banner.duration = TimeInterval(duration)
    banner.show(queuePosition: .front)
}

func showBannerAlert(type: BannerStyle = .success, title: String = APPNAME, messages: [String] , duration: Int = 3, onTap : (()->())? = nil)
{
    var message = ""
    for index in 0 ..< messages.count {
        message.append("• " + messages[index] + "\n")
    }
    showBannerAlert(type: type, title: title, message: message, duration: duration, onTap: onTap)
}

func showStatusBarAlert(title: String, duration: Int = 5,type: BannerStyle = .success, onTap : (()->())? = nil)
{
    NotificationBannerQueue.default.removeAll()
    let banner = StatusBarNotificationBanner(title: title, style: type)
    banner.onTap = onTap
    banner.duration = TimeInterval(duration)
    banner.show(queuePosition: .front)
}
