//
//  UICodChargeToCustomerViewController.swift
//  XPDriver
//
//  Created by Waseem  on 31/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit
@_exported import SwiftyJSON
@_exported import Alamofire


@objcMembers
class UICodChargeToCustomerViewController: UIViewController {
    
    @IBOutlet weak var lblOrderCash: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    var order: Order? = nil
    var handlerSuccess: (([String: Any])->())? = nil
    var latLong = ""
    var address = ""
    
    var statusBar: UIStatusBarStyle = .lightContent
    
    var totalPrice: Double {
        Double(order?.totalprice ?? 0.0).rounded(toPlaces: 2)
    }
    var currencyCode: String {
        order?.currrencyCode ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        lblOrderCash.text = order?.totalAmount ?? ""
        lblCurrency.text = " \(currencyCode)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            statusBar = .darkContent
        } else {
            statusBar = .default
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        
        statusBar = .lightContent
        
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBar
    }
    
    //MARK: - IBAction -
    
    @IBAction func onClickBack() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func onClickCheckOut() {
        self.view.endEditing(true)
        //        let data = getDummyOrder()
        //        print("** wk data: \(data.dictionaryObject ?? [:])")
        //        self.handlerSuccess?(data.dictionaryObject ?? [:])
        
        if UtilAvailability.shouldDisable {
            Task {
                await UtilAvailability.shared.showDummyLoading(con: self)
            }
        } else {
            codPaymentConfirmation()
        }
    }
    
    //MARK: - Api Calls -
    
    func codPaymentConfirmation() {
        self.showHud()
        let arrayLatLong = latLong.components(separatedBy: ",")
        var params: [String: Any] = [
            "command": "codPaymentReceiveConfirmationOptimized",
            "order_id": order?.orderId ?? 0.0,
            "amount": totalPrice,
            "address":  address
        ]
        if arrayLatLong.count >= 2 {
            params["user_lat"] = arrayLatLong[0]
            params["user_lng"] = arrayLatLong[1]
        }
        
        AF.request("https://www.xpeats.com/api/index.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
            .responseJSON1 { response in
                self.hideHud()
                if let error = response.error {
                    print("** wk failure 1: \(error)")
                } else {
                    if let json = response.value {
                        print("** wk json: \(json)")
                        
                        if json["success"].boolValue {
                            //                            self.onClickBack()
                            if let navController = self.navigationController {
                                navController.popViewController(animated: false)
                            }
                            let orderId = Int(self.order?.orderId ?? "0") ?? 0
                            if let data = json["data"].arrayValue.filter({$0["orderId"].intValue == orderId}).first {
                                self.handlerSuccess?(data.dictionaryObject ?? [:])
                            }
                        } else {
                            self.showAlert(message: json["msg"].stringValue)
                        }
                    }
                }
            }
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
