//
//  UIOrderTableViewCell.swift
//  XPDriver
//
//  Created by Waseem  on 23/09/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

enum KOrderStatus: Int {
    case Unknown = -1
    case Assigned = 1
    case Accepted = 2
    case Reached = 3
    case PickedUp = 4
    case Delivered = 5
    case Rejected = 6
    case Skipped = 7
    
    var title: String {
        switch self {
        case .Assigned:
            ""
        case .Accepted:
            "ARRIVED"
        case .Reached:
            "PICKED UP"
        case .PickedUp:
            "DELIVERED"
        case .Delivered:
            "DELIVERED"
        case .Rejected:
            ""
        case .Skipped:
            ""
        case .Unknown:
            "Unknown"
        }
    }
}

@objc class UIOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var viewCOD: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var addressLabel1: UILabel!
    @IBOutlet weak var lblCodOrderPrice: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusButton: RoundedButton!
    @IBOutlet weak var lblOrderNumber: UILabel!
    
    @objc weak var delegate: OrderTableViewCellDelegate?
    private var order: Order?
    
    var handler: (()->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc static func identifier() -> String {
        return String(describing: self)
    }
    
    @objc func configure(with order: Order, handler: (()->())? = nil) {
        self.order = order
        self.handler = handler
        
        var note = ""
        var address = ""
        var vendorAddress = ""
        
        orderNumberLabel.text = "Order No: \(order.orderId)"
        lblOrderNumber.text = order.orderId
        deliveryTimeLabel.text = "\(order.distance)"
        viewBack.borderWidth = order.isActive ? 3 : 1
        viewBack.borderColor = order.isActive ? UIColor(hex: 0x24C24E) : UIColor(hex: 0xf2f2f2)
        
        viewCOD.isHidden = order.paymentMethod != "cod"
        
        if order.isPickedUp || order.isDelivered {
            nameLabel.text = order.customer.name
            note = order.buyerNote
            address = order.dropAddress
        } else {
            nameLabel.text = order.restaurant.name
            
            if KOrderStatus.Reached.rawValue == Int(order.status) {
                note = order.buyerNote
                address = order.dropAddress
                addressLabel1.text = "Address: \(order.dropAddress)"
            } else {
                note = ""
                if order.paymentMethod == "cod" {
                    address = order.restaurant.address
                } else {
                    vendorAddress = order.restaurant.address
                }
            }
        }
        
        if !note.isEmpty {
            noteLabel.text = "Note: \(order.buyerNote)"
        }
        
        if !address.isEmpty {
            if !order.aptNumber.isEmpty {
                address = "Apt.\(order.aptNumber) \(address)"
            }
            addressLabel1.text = "Address: \(address)"
        } else if !vendorAddress.isEmpty {
            if !order.aptNumber.isEmpty {
                address = "Apt.\(order.aptNumber) \(vendorAddress)"
            }
            addressLabel1.text = "Vendor Address: \(order.restaurant.address)"
        }
        
        if order.paymentMethod == "cod" {
            lblCodOrderPrice.text = order.fullPrice
            priceLabel.text = order.driverFee
        } else {
            lblCodOrderPrice.text = ""
            priceLabel.text = order.fullPrice
        }
        
        let url = !order.isPickedUp && !order.isDelivered ? order.brandLogoUrl : order.customer.imageURL
        imgView.loadImageFromURL(url)
        
        setStatusButtonTitle()
    }
    
    private func loadImageFromURL(for order: Order) {
        let url = !order.isPickedUp && !order.isDelivered ? order.brandLogoUrl : order.customer.imageURL
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.imgView.image = image
                }
            } else {
                print("Failed to create image from data")
            }
        }.resume()
    }
    
    private func setStatusButtonTitle() {
        statusButton.isHidden = false
        
        let value = Int(order?.status ?? 0)
        if let status = KOrderStatus(rawValue: value) {
            statusButton.setTitle(status.title, for: .normal)
            
            switch status {
            case .Reached:
                statusButton.backgroundColor = UIColor(hex: 0x24C24E)
            case .PickedUp:
                statusButton.backgroundColor = UIColor(hex: 0xEC0503)
            case .Delivered:
                statusButton.backgroundColor = UIColor(hex: 0xEC0503)
            case .Assigned:
                statusButton.isHidden = true
                statusButton.backgroundColor = UIColor(hex: 0x394158)
            default:
                statusButton.isHidden = true
                statusButton.backgroundColor = UIColor(hex: 0x394158)
            }
        }
        
        statusButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        if let order = order {
            delegate?.infoButtonPressed(order)
        }
    }
    
    @IBAction func statusButtonPressed(_ sender: UIButton) {
        if let order = order {
            delegate?.statusButtonPressed(order)
        }
    }
    
    @IBAction func onCllickCell() {
        handler?()
    }
    
    @IBAction func onClickCall() {
        if let order = order {
            let phoneNumber = "telprompt://" + order.customer.phone
            let cleanedString = phoneNumber.components(separatedBy: CharacterSet(charactersIn: "0123456789-+()").inverted).joined()
            if let escapedPhoneNumber = cleanedString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let phoneURL = URL(string: "telprompt:\(escapedPhoneNumber)") {
                UIApplication.shared.open(phoneURL, options: [:])
            }
        }
    }
}
