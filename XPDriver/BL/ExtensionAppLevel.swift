//
//  ExtensionAppLevel.swift
//  XPDriver
//
//  Created by Waseem  on 19/09/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation 
@_exported import SwiftyJSON
@_exported import Kingfisher

extension UIImageView {
    func loadImageFromURL(_ url: String,_ placeHolder:String? = nil,_ showIndicator:Bool = true,_ indicatorStyle: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.medium, completionHandler : ((Swift.Result<Kingfisher.RetrieveImageResult, Kingfisher.KingfisherError>) -> Void)? = nil)
    {
        kf.indicatorType = (showIndicator ? .activity : .none)
        (kf.indicator?.view as? UIActivityIndicatorView)?.style = indicatorStyle;
        
        let options : KingfisherOptionsInfo = [.transition(.fade(0.5))]
        
        if let placeHolderName = placeHolder
        {
            kf.setImage(with: URL(string: url), placeholder: UIImage(named: placeHolderName), options: options, completionHandler: completionHandler)
        }
        else
        {
            kf.setImage(with: URL(string: url), options: options,completionHandler: completionHandler)
        }
    }
    
    func loadImageFromURL(_ url: URL,_ placeHolder:String? = nil,_ showIndicator:Bool = true,_ indicatorStyle: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.medium, completionHandler : ((Swift.Result<Kingfisher.RetrieveImageResult, Kingfisher.KingfisherError>) -> Void)? = nil)
    {
        kf.indicatorType = (showIndicator ? .activity : .none)
        (kf.indicator?.view as? UIActivityIndicatorView)?.style = indicatorStyle;
        
        let options : KingfisherOptionsInfo = [.transition(.fade(0.5))]
        
        if let placeHolderName = placeHolder
        {
            kf.setImage(with: url, placeholder: UIImage(named: placeHolderName), options: options, completionHandler: completionHandler)
        }
        else
        {
            kf.setImage(with: url, options: options,completionHandler: completionHandler)
        }
    }
}

func checkIsNewVersion(olderVersion: String, newVersion: String) -> Bool {
    // Check if olderVersion (localVersion) is greater than newVersion. If so, ignore the update.
    if olderVersion.compare(newVersion, options: .numeric) == .orderedDescending {
        print("Local version (olderVersion) is greater than the new version. Ignoring update.")
        return false
    }
    
    // Check if the new version is greater than the older version.
    return olderVersion.compare(newVersion, options: .numeric) == .orderedAscending
}

//func randomString(length: Int) -> String {
//    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//    return String((0..<length).map{ _ in letters.randomElement()! })
//}
