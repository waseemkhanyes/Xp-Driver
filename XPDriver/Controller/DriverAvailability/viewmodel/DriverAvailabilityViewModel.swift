//
//  DriverAvailabilityViewModel.swift
//  XPDriver
//
//  Created by Waseem  on 01/11/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation

protocol DriverAvailabilityOperations {
    func reloadData()
    func showLoading()
    func hideLoading()
    func showErrorMessage(message: String)
}

class DriverAvailabilityViewModel: NSObject {
    
    var arrayAvailability: [JSON] = []
    var arrayLocations: [JSON] = []
    var delegate: DriverAvailabilityOperations? = nil
    var strMonth: String = ""
    
    //MARK: - Api Calls -
    
    //https://xpeats.com/api/index.php?command=addDriverAvailablity&driver_id=3550&dates=2024-10-01,2024-10-02,2024-10-03&status=available
    
    //https://xpeats.com/api/index.php?command=getDriverAvailability&driver_id=2631&month=2024-10
    
    func getAvailability() {
        self.delegate?.showLoading()
        let params: [String: Any] = [
            "command"   :   "getDriverAvailability",
            "driver_id" :   CodManager.currentUser().userId ?? "",
            "month"     :   strMonth,
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
                        self.arrayAvailability = json["data"].arrayValue
                        var arrayLocations = json["attacched_locations"].arrayValue
                        var arrayForAll: [JSON] = []
                        if let location = arrayLocations.first {
                            arrayForAll = location["delivery_schedule"].arrayValue
                            
                            arrayLocations.forEach({ item in
                                item["delivery_schedule"].arrayValue.forEach({ schedule in
                                    if schedule["special"].stringValue == "open" {
                                        arrayForAll = arrayForAll.map({ item in
                                            var item = item
                                            if item["day"].stringValue == schedule["day"].stringValue {
                                                item["special"] = "open"
                                            }
                                            return item
                                        })
                                    }
                                })
                            })
                            
                            arrayLocations = [JSON(["locationId": -1, "name": "All", "delivery_schedule": arrayForAll])] + arrayLocations
                        }
                        
                        self.arrayLocations = arrayLocations
                        self.delegate?.reloadData()
                    } else {
                        self.delegate?.showErrorMessage(message: json["msg"].stringValue)
                    }
                }
            }
    }
    
    func addDriverAvailability(status: String, _ dates: [Date]) {
    
        self.delegate?.showLoading()
        let params: [String: Any] = [
            "command"   :   "addDriverAvailablity",
            "driver_id" :   CodManager.currentUser().userId ?? "",
            "dates"     :   dates.map({$0.in(region: .local).toFormat("yyyy-MM-dd")}).joined(separator: ","),
            "status"    :   status
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
                        self.getAvailability()
                    } else {
                        self.delegate?.showErrorMessage(message: json["msg"].stringValue)
                    }
                }
            }
    }
}

