//
//  UICodPaymentHeaderViewCell.swift
//  XPDriver
//
//  Created by Waseem  on 31/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UICodPaymentHeaderViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBack: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewBack.setCornerRadius(cornerRadius: 8, corners: [.TopLeft, .TopRight])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config() {
        
    }
    
    @IBAction func onClickPlus() {
        
    }
    
}
