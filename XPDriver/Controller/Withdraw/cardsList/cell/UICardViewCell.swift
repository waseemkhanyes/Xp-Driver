//
//  UICardViewswift
//  XPDriver
//
//  Created by Waseem  on 13/02/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UICardViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var currencyLabel: UILabel!
    
    //MARK: - Variables -
    
    var handler: ((Bool)->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.setShadowToView(cornerRadius: 3, shadowRadius: 3.0, shadowOpacity: 0.1, shadowColor: .black, shadowOffset: CGSize(width: 0, height: 4))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configData(card: JSON, _ handler: ((Bool)->())? = nil) {
        self.handler = handler
        let isActive = card["status"].boolValue
        cardNameLabel.text = card["creditcardtype"].stringValue
        cardNumberLabel.text = "••••\(card["last4"].stringValue)"
        let image = UIImage(named: isActive ? "ic_card_selected" : "ic_card_unselected")
        statusImageView.image = image
        backView.backgroundColor = card["status"].boolValue ? UIColor(hex: 0xF1F7FC) : UIColor(hex: 0xFAFAFA)
    }
    
    @IBAction func onClickRemove() {
        handler?(false)
    }
    
    @IBAction func onClickCard() {
        handler?(true)
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int,alpha: Double = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    
    convenience init(hex: Int,alpha: Double = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            alpha: alpha
        )
    }
    
    convenience init(hex: String, alpha: Double = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
    func alpha(_ alpha: Float = 1.0) -> UIColor {
        return self.withAlphaComponent(CGFloat(alpha))
    }
    
    static var random: UIColor {
        return .init(hue: .random(in: 0...360), saturation: 1, brightness: 1, alpha: 1)
    }
    
    static var RGBRandom: UIColor {
        return .init(red: Int.random(in: 0..<256), green: Int.random(in: 0..<256), blue: Int.random(in: 0..<256))
    }
    
    static var randomDark: UIColor {
        return .init(hue: .random(in: 0...360), saturation: 1, brightness: 0.5, alpha: 1)
    }
    
    static func getColours(count:Int) -> [UIColor] {
        return (0..<count).map { _ in random }
    }
    
}
