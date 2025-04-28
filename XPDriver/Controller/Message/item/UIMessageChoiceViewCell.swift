//
//  UIMessageChoiceViewCell.swift
//  XPDriver
//
//  Created by Waseem  on 28/03/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UIMessageChoiceViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var viewBack: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
//        imgTick.image = imgTick.image?.withRenderingMode(.alwaysTemplate)
//        imgTick.tintColor = UIColor.green
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(item: JSON, selected: Bool) {
        imgTick.isHidden = !selected
        viewBack.borderColor = selected ? UIColor(hex: 0x0D2048) : UIColor.lightGray
        if item["message_sent"].boolValue {
            viewBack.borderColor = UIColor(hex: 0x0D2048)
            imgTick.isHidden = false
            contentView.alpha = 0.5
        } else {
            contentView.alpha = 1.0
        }
        lblOption.text = item["time_slot_name"].stringValue
    }
    
    func configForAttachedDriver(item: JSON, selected: Bool) {
        imgTick.isHidden = !selected
        viewBack.borderColor = selected ? UIColor(hex: 0x0D2048) : UIColor.lightGray
        lblOption.text = item["name"].stringValue
    }
    
}
