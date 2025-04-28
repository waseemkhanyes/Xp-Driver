//
//  OrderUtil.swift
//  XPDriver
//
//  Created by Waseem  on 11/12/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation


@objcMembers
class OrderUtil: NSObject {
    static var shared: OrderUtil = OrderUtil()
    
    @objc
    func checkNeedToShowAlert(_ order: Order) -> String? {
        guard let deliveryDate = order.deliveryDate.toDate("yyyy-MM-dd") else {
            return nil
        }
    
        let dayDifference = deliveryDate.dateAtStartOf(.day).difference(in: .day, from: Date().in(region: .local).dateAtStartOf(.day)) ?? 0

       switch dayDifference {
       case 0:
           return nil
       case 1:
           return "This delivery is for tomorrow, are you sure you want to accept it?"
       case let days where days > 1:
           // After tomorrow
           let dayName = deliveryDate.toFormat("EEEE") // Full day name (e.g., Friday)
           let formattedDate = deliveryDate.toFormat("MMMM d") // Month and day (e.g., December 15)
           return "This delivery is for \(dayName) \(formattedDate), are you sure you want to accept it?"
       default:
           return nil
       }
    }
}
