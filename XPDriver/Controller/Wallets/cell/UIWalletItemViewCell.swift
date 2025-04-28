//
//  UIWalletItemViewCell.swift
//  XPDriver
//
//  Created by Waseem  on 11/03/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UIWalletItemViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var lblDefault: UILabel!
    
    var handler: ((Bool)->())? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(data: JSON, _ handler: ((Bool)->())? = nil) {
        self.handler = handler
        lblCurrency.text = data["country_name"].stringValue
//        lblAmount.text = data["active_balance"].stringValue
        lblAmount.text = data["available_balance"].stringValue
        let isDefault = data["is_default"].boolValue
        lblDefault.isHidden = !isDefault
        viewMenu.isHidden = isDefault
    }
    
    @IBAction func onClickItem() {
        handler?(false)
    }
    
    @IBAction func onClickMenu() {
        handler?(true)
    }
    
}
