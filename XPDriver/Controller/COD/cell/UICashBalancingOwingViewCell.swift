//
//  UICashBalancingOwingViewCell.swift
//  XPDriver
//
//  Created by Waseem  on 31/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UICashBalancingOwingViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtAmount: UITextField!
    
    var handler: ((Double)->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let amount = Double(textField.text ?? "0") ?? 0.0
        handler?(amount)
    }
    
}
