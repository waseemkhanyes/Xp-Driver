//
//  UIMapForLocatonAndOrderPinsViewController.swift
//  XPDriver
//
//  Created by Waseem  on 16/12/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit
import GoogleMaps
import IQDropDownTextField

class UIMapForLocatonAndOrderPinsViewController: UIViewController, MapPinsDataOperations, IQDropDownTextFieldDelegate {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtDate: IQDropDownTextField!
    @IBOutlet weak var lblLocation: UILabel!
    
    //MARK: - Variables -
    
    var viewModel: MapLocationAndOrderPinsViewModel = MapLocationAndOrderPinsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        self.navigationItem.title = "Map"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE dd MMM, yyyy"
        
        txtDate.dateFormatter = dateFormatter
        
        txtDate.delegate = self
        txtDate.dropDownMode = .datePicker
        
        let today = dateFormatter.string(from: Date())
        txtDate.selectedItem = today
        viewModel.getDriverAssignedLocations(today)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func drawPins() {
        mapView.clear()
        
        var isFirstPin = false
        let shouldMoveToLocationPin = viewModel.selectedLocation.count > 0
        for location in viewModel.arrayFilteredLocations {
            let orders = location["orders"].arrayValue
            configLocationPin(name: location["name"].stringValue, CLLocationCoordinate2D(latitude: location["latitude"].doubleValue, longitude: location["longitude"].doubleValue))
            if shouldMoveToLocationPin && self.viewModel.selectedLocation["id"].intValue == location["id"].intValue {
                moveToCoordinate(lat: location["latitude"].doubleValue, lng: location["longitude"].doubleValue)
            } else if !isFirstPin && !shouldMoveToLocationPin {
                isFirstPin = true
                moveToCoordinate(lat: location["latitude"].doubleValue, lng: location["longitude"].doubleValue)
            }
            
            for order in orders {
                let drop_coordinate = order["drop_coordinate"].stringValue.split(separator: ",").map({Double($0) ?? 0.0})
                if drop_coordinate.count == 2 {
                    configOrderPin(name: "Order: #\(order["id"].intValue)", CLLocationCoordinate2D(latitude: drop_coordinate[0], longitude: drop_coordinate[1]))
                }
            }
        }
    }
    
    func configLocationPin(name: String, _ coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = name
        marker.icon = UIImage(named: "pickup_point")
        marker.map = mapView // Add marker to the map
    }
    
    func configOrderPin(name: String, _ coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = name
        marker.icon = UIImage(named: "drop_point")
        marker.map = mapView // Add marker to the map
    }
    
    func moveToCoordinate(lat: Double, lng: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 13.0)
        mapView.animate(to: camera)
    }
    
    //MARK: - IBActions -
    
    @IBAction func onClickLocationDropDown() {
        let controller = UIDriverAttachedLocationsPopupViewController()
        var orders = [JSON(["id": "0", "name": "Select Location"])]
        orders.append(contentsOf: viewModel.arrayLocations)
        controller.arrayLocations = orders
        controller.selected = viewModel.selectedLocation
        controller.isFromMap = true
        controller.handler = { location in
            self.viewModel.selectedLocation = location
            print("** wk selectedLocation: \(location)")
            self.lblLocation.text = location["name"].stringValue
            self.lblLocation.textColor = .black
            
            if location["id"].intValue > 0 {
                self.viewModel.arrayFilteredLocations = [location]
            } else {
                self.viewModel.selectedLocation = JSON([:])
                self.viewModel.arrayFilteredLocations = self.viewModel.arrayLocations
            }
            self.drawPins()
        }
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: - MapPinsDataOperations -
    
    func reloadData() {
        drawPins()
    }
    
    func showLoading() {
        self.showHud()
    }
    
    func hideLoading() {
        self.hideHud()
    }
    
    func showErrorMessage(message: String) {
        self.showAlert(message: message)
    }
    
    //MARK: - IQDropDownTextFieldDelegate -
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("** wk date: \(textField.text ?? "")")
        if let date = textField.text {
            self.lblLocation.text = "Select Location"
            viewModel.getDriverAssignedLocations(date)
        }
    }
    
    @IBAction func onClickScan() {
        showAlertForScanAndInputOrder()
    }

    func showAlertForScanAndInputOrder() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Scan Order", style: .default, handler: { _ in
            let scanner = UICustomScannerViewController()
            scanner.handlerSuccess = { orderId in
                self.viewModel.acceptOrderByQrCode(orderId)
            }
            self.navigationController?.pushViewController(scanner, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Enter Order Id", style: .default, handler: { _ in
            let popupController = UIAcceptOrderByIdPopupViewController()
            popupController.handlerSuccess = { orderId in
                self.viewModel.acceptOrderByQrCode(orderId)
            }
            
            popupController.modalPresentationStyle = .overCurrentContext
            popupController.modalTransitionStyle = .coverVertical
            self.present(popupController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
