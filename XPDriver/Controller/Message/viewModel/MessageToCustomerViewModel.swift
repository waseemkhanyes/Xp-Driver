//
//  MessageToCustomerViewModel.swift
//  XPDriver
//
//  Created by Waseem  on 28/03/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation

protocol MessageOperations {
    func reloadData()
    func showLoading()
    func hideLoading()
    func showErrorMessage(message: String)
}

class MessageToCustomerViewModel: NSObject {
    
    var arrayOptions: [JSON] = []
    var delegate: MessageOperations? = nil
    var selectedOptionId = ""
    var orderId: String = ""
    
    func checkSelected(item: JSON) -> Bool {
        return item["id"].stringValue == selectedOptionId
    }
    
    //MARK: - Api Calls -
    
    func getTimeSlotsForMessageApi() {
        self.delegate?.showLoading()
        let params: [String: Any] = [
            "command"   :   "getTimeSlotsForMessage",
            "order_id"  :   orderId
        ]
        
        print("** wk params: \(params)")
        AF.request("https://www.xpeats.com/api/index.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
            .responseJSON1 { response in
                self.delegate?.hideLoading()
                if let error = response.error {
                    self.delegate?.showErrorMessage(message: error.localizedDescription)
                } else if let json = response.value {
                    if json["success"].boolValue {
                        self.arrayOptions = json["data"].arrayValue
                        self.delegate?.reloadData()
                    } else {
                        self.delegate?.showErrorMessage(message: json["msg"].stringValue)
                    }
                }
            }
    }
    
    func sendMessageToCustomerApi(_ handler: (()->())? = nil) {
        self.delegate?.showLoading()
        let params: [String: Any] = [
            "command"   :   "sendMessageToCustomer",
            "time_slot_id" :   selectedOptionId,
            "order_id"  :   orderId
        ]
        
        print("** wk params: \(params)")
        AF.request("https://www.xpeats.com/api/index.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
            .responseJSON1 { response in
                self.delegate?.hideLoading()
                if let error = response.error {
                    self.delegate?.showErrorMessage(message: error.localizedDescription)
                } else if let json = response.value {
                    if json["success"].boolValue {
                        handler?()
                    } else {
                        self.delegate?.showErrorMessage(message: json["msg"].stringValue)
                    }
                }
            }
    }
}
