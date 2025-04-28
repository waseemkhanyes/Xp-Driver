//
//  CustomLocation.swift
//  XPDriver
//
//  Created by Waseem  on 13/09/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation
import UIKit

@objc class CustomLocation: NSObject {
    
    @objc static var lati: String = "43.11129"
    @objc static var longi: String = "-80.307204"
    @objc static var isActive: Bool = false
    
    static func saveCustomLocation(lat: String, long: String, active: Bool) {
        
        let locationData: [String: String] = ["latitude": lat, "longitude": long, "active": active ? "yes" : "no"]
        
        // Save the dictionary to UserDefaults
        UserDefaults.standard.set(locationData, forKey: "savedLocation")
        
        // Optionally, you can show a confirmation message to the user
        CustomLocation.lati = lat
        CustomLocation.longi = long
        CustomLocation.isActive = active
        print("Location saved!")
    }
    
    @objc static func retrieveSavedLocation() {
        if let savedLocation = UserDefaults.standard.dictionary(forKey: "savedLocation") as? [String: String] {
            let lati = savedLocation["latitude"] ?? ""
            let longi = savedLocation["longitude"] ?? ""
            let active = savedLocation["active"] ?? ""
            
            
            CustomLocation.lati = lati
            CustomLocation.longi = longi
            CustomLocation.isActive = active == "yes" ? true : false
            
            // Use the retrieved latitude and longitude
            print("Retrieved Latitude: \(CustomLocation.lati)")
            print("Retrieved Longitude: \(CustomLocation.longi)")
            print("Retrieved isActive: \(CustomLocation.isActive)")
        } else {
            print("No saved location found.")
        }
    }
    
}
