//
//  UIPaymentCardViewCell.swift
//  XPDriver
//
//  Created by Waseem  on 31/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UIPaymentCardViewCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(data: JSON, shouldLast: Bool = false) {
        lblName.text = data["name"].stringValue
        lblNumber.text = data["card_number"].stringValue
        
        lblBottomLine.isHidden = shouldLast
        viewBack.setCornerRadius(cornerRadius: shouldLast ? 8 : 0, corners: [.BottomLeft, .BottomRight])
    }
    
}
