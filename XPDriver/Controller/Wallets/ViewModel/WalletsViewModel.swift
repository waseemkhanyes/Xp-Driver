//
//  WalletsViewModel.swift
//  XPDriver
//
//  Created by Waseem  on 27/03/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation

protocol WalletOperations {
    func reloadData()
    func showLoading()
    func hideLoading()
    func showErrorMessage(message: String)
}

class WalletsViewModel: NSObject {
    var arrayWallet: [JSON] = []
    var delegate: WalletOperations? = nil
    
    //MARK: - Api Calls -
    
    func getUserWallets() {
        self.delegate?.showLoading()
        let params: [String: Any] = [
            "command"   :   "my_account1",
            "user_id"   :   CodManager.currentUser().userId ?? "",
            "page"    :   "1",
            "limit"    :   "1"
        ]
        
        print("** wk params: \(params)")
        AF.request("https://www.xpeats.com/api/index.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
            .responseJSON1 { response in
                self.delegate?.hideLoading()
                if let error = response.error {
                    print("** wk failure 1: \(error)")
                    self.delegate?.showErrorMessage(message: error.localizedDescription)
                } else if let json = response.value {
                    print("** wk json: \(json)")
                    if json["success"].boolValue {
                        self.arrayWallet = json["data"]["user_wallets"].arrayValue
                        self.delegate?.reloadData()
                    } else {
                        self.delegate?.showErrorMessage(message: json["msg"].stringValue)
                    }
                }
            }
    }
    
    func makeDefaultWalletApi(walletId: Int) {
        self.delegate?.showLoading()
        let params: [String: Any] = [
            "command"   :   "makeWalletDefault",
            "user_id"   :   CodManager.currentUser().userId ?? "",
            "wallet_id" :   walletId
        ]
        
        print("** wk params: \(params)")
        AF.request("https://www.xpeats.com/api/index.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
            .responseJSON1 { response in
                self.delegate?.hideLoading()
                if let error = response.error {
                    print("** wk failure 1: \(error)")
                    self.delegate?.showErrorMessage(message: error.localizedDescription)
                } else if let json = response.value {
                    print("** wk json: \(json)")
                    if json["success"].boolValue {
                        self.arrayWallet = json["data"]["user_wallets"].arrayValue
                        self.delegate?.reloadData()
                    } else {
                        self.delegate?.showErrorMessage(message: json["msg"].stringValue)
                    }
                }
            }
    }
}
