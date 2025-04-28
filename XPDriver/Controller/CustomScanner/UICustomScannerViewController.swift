//
//  UICustomScannerViewController.swift
//  XPDriver
//
//  Created by Waseem  on 18/04/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit
import SwiftQRCodeScanner

@objcMembers
class CustomScnner: NSObject, QRScannerCodeDelegate {
    
    static var shared = CustomScnner()
    let scanner = QRCodeScannerController()
    var handlerClose: (()->())? = nil
    var handlerSuccess: ((String)->())? = nil
    
    //MARK: - QRScannerCodeDelegate -
    
    func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String) {
        print("** wk didScanQRCodeWithResult: \(result)")
        handlerSuccess?(result)
    }
    
    func qrScanner(_ controller: UIViewController, didFailWithError error: SwiftQRCodeScanner.QRCodeError) {
        print("** wk didFailWithError: \(error.localizedDescription)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
        handlerClose?()
    }
}


@objcMembers
class UICustomScannerViewController: UIViewController, QRScannerCodeDelegate {
    
    var handlerSuccess: ((String)->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scanner = QRCodeScannerController()
        scanner.delegate = self
//        self.view.addSubview(scanner)
                self.present(scanner, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - QRScannerCodeDelegate -
    
    func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String) {
        print("** wk didScanQRCodeWithResult: \(result)")
        self.navigationController?.popViewController(animated: false)
        handlerSuccess?(result)
    }
    
    func qrScanner(_ controller: UIViewController, didFailWithError error: SwiftQRCodeScanner.QRCodeError) {
        print("** wk didFailWithError: \(error.localizedDescription)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
        self.navigationController?.popViewController(animated: false)
    }
    
}
