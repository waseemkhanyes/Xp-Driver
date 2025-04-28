//
//  BarChartFormatter.swift
//  A1Driver
//
//  Created by Macbook on 30/07/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//
import UIKit
import Foundation
import Charts
@objc(BarChartFormatter)
public class BarChartFormatter: NSObject {
    var days: [String]! = []
    @objc public init(data: [String]) {
        super.init()
        self.days = data
    }
    
    @objc public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return days[Int(value)]
    }
}
