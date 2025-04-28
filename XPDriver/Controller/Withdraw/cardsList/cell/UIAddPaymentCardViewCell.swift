//
//  UIAddPaymentCardViewCell.swift
//  XPDriver
//
//  Created by Waseem  on 14/02/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UIAddPaymentCardViewCell: UITableViewCell {
    
    var handler: (()->())? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickAdd() {
        handler?()
    }
    
}
