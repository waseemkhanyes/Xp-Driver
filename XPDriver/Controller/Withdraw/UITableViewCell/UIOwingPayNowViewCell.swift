//
//  UIOwingPayNowViewCell.swift
//  XPDriver
//
//  Created by Waseem  on 13/02/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UIOwingPayNowViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblButtonTitle: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickPayNow() {
        
    }
}
