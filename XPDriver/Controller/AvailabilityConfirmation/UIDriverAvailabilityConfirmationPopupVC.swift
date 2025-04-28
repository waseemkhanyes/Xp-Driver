//
//  UIDriverAvailabilityConfirmationPopupVC.swift
//  XPDriver
//
//  Created by Waseem  on 15/11/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

@objc class UIDriverAvailabilityConfirmationPopupVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!

    @objc var data: [String: Any]? = nil
    
    var dicData: JSON = JSON([:])

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data {
            dicData = JSON(data)
            print("** wk data: \(dicData)")
            lblTitle.text = dicData["alert"]["title"].stringValue
            lblDetail.text = dicData["msg"].stringValue
        }
    }
    
    @IBAction func onClickCross() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onClickAvailable() {
        updateAvailabilityStatusApi(status: "available")
    }
    
    @IBAction func onClickNotAvailable() {
        updateAvailabilityStatusApi(status: "not-available")
    }

// https://xpeats.com/api/index.php?command=sendNotificationtoDriver&driver_id=1796&message=Test%20Message&date_from=2024-11-15&date_to=2024-11-15
//    https://xpeats.com/api/index.php?command=updateAvailabilityStatus&date_from=2024-11-15&date_to=2024-11-15&driver_id=1796&status=available
    
    //MARK: - API CALLS -
    
    func updateAvailabilityStatusApi(status: String) {
        self.showHud()
        let params: [String: Any] = [
            "command"       :   "updateAvailabilityStatus",
            "driver_id"     :   CodManager.currentUser().userId ?? "",
            "date_from"     :   dicData["data"]["date_from"].stringValue,
            "date_to"       :   dicData["data"]["date_to"].stringValue,
            "status"        :   status,
        ]
        
        print("** wk params: \(params)")
        AF.request("https://www.xpeats.com/api/index.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
            .responseJSON1 { response in
                self.hideHud()
                print("** wk response: \(response)")
                if let error = response.error {
                    print("** wk failure 1: \(error)")
                    
                } else if let json = response.value {
                    print("** wk json: \(json)")
                    if json["success"].boolValue {
                        self.dismiss(animated: true)
                    } else {
                        
                    }
                }
            }
    }
}
