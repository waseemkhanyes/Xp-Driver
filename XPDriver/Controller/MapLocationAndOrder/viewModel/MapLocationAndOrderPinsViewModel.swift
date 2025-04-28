//
//  MapLocationAndOrderPinsViewModel.swift
//  XPDriver
//
//  Created by Waseem  on 16/12/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation

protocol MapPinsDataOperations {
    func reloadData()
    func showLoading()
    func hideLoading()
    func showErrorMessage(message: String)
}

class MapLocationAndOrderPinsViewModel: NSObject {
    var arrayLocations: [JSON] = []
    var arrayFilteredLocations: [JSON] = []
    var selectedLocation: JSON = JSON([:])
    var delegate: MapPinsDataOperations? = nil
    
    //MARK: - Api Calls -
    
    func getDriverAssignedLocations(_ date: String? = nil, shouldClear: Bool = true) {
        self.delegate?.showLoading()
        var params: [String: Any] = [
            "command"   :   "getDriverAssignedLocationsAndActiveOrders",
            "driver_id"   :   CodManager.currentUser().userId ?? "",
        ]
        
        if let date {
            params["date"] = date
        }
        
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
                        self.arrayLocations = json["data"].arrayValue
                        self.arrayFilteredLocations = self.arrayLocations
                        if shouldClear {
                            self.selectedLocation = JSON([:])
                        }
                        
                        self.delegate?.reloadData()
                    } else {
                        self.delegate?.showErrorMessage(message: json["msg"].stringValue)
                    }
                }
            }
    }
    
    func acceptOrderByQrCode(_ orderId: String? = nil) {
        
        let dcoordi = UserDefaults.standard.string(forKey: "Driver Coordinate")
        
        let testUser = CodManager.currentUser().testUser == "1" && CustomLocation.isActive;
        
        let arrayCoordinates = dcoordi?.split(separator: ",").map({"\($0)"}) ?? []
        
        guard arrayCoordinates.count >= 2 else { return }
        
        self.delegate?.showLoading()
        let params: [String: Any] = [
            "command"       :   "acceptOrderByQrCode",
            "driver_id"     :   CodManager.currentUser().userId ?? "",
            "order_id"      :   orderId ?? "",
            "lat"           :   testUser ? CustomLocation.lati : arrayCoordinates[0],
            "long"          :   testUser ? CustomLocation.longi : arrayCoordinates[1],
            
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
                        self.getDriverAssignedLocations(shouldClear: false)
                    } else {
                        self.delegate?.showErrorMessage(message: json["msg"].stringValue)
                    }
                }
            }
    }
}
