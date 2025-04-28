//
//  CustomApiCalling.swift
//  XPDriver
//
//  Created by Waseem  on 05/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation

@objc(CustomApiCalling)
class CustomApiCalling: NSObject {
    // Your Swift code here
    
    @objc func callLogTest() {
        print("wk check logs")
    }
}

func viewBalanceApi() {
    
    AF.request("", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authkey" : "123456"]).responseJSON { response in
    }
}
