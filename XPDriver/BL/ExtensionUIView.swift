//
//  ExtensionUIView.swift
//  XPDriver
//
//  Created by Waseem  on 31/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit
import Foundation

//Mark: - For Desiging -

extension UIView {
    enum Corners: Int {
        case TopLeft = 0
        case TopRight
        case BottomLeft
        case BottomRight
        
        var cornerMask: CACornerMask {
            switch self {
            case .TopLeft:
                return .layerMinXMinYCorner
            case .TopRight:
                return .layerMaxXMinYCorner
            case .BottomLeft:
                return .layerMinXMaxYCorner
            case .BottomRight:
                return .layerMaxXMaxYCorner
            }
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    var firstResponder: UIResponder? {
        if isFirstResponder {
            return self
        } else {
            for view in subviews {
                if let responder = view.firstResponder {
                    return responder
                }
            }
            return nil
        }
    }
    
    func setCornerRadius(cornerRadius: Double = 5, corners:[Corners] = [])
    {
        if corners.count > 0 {
            if #available(iOS 11.0, *) {
                var cornerMask:CACornerMask = []
                for corner in corners {
                    cornerMask.insert(corner.cornerMask)
                }
                
                self.layer.maskedCorners = cornerMask
            }
        } else {
            if #available(iOS 11.0, *) {
                self.layer.maskedCorners = []
            } else {
                // Fallback on earlier versions
            }
        }
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(cornerRadius)
        
        
    }
    
    func setCornerRadius(cornerRadius: Double = 5)
    {
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    func setCircle()
    {
        setCornerRadius(cornerRadius: Double(frame.size.height * 0.5))
    }
    
    func setRoundedCorners()
    {
        setCornerRadius(cornerRadius: Double(frame.size.height * 0.5))
    }
    
    func setBorder(color: UIColor = UIColor.white, borderWidth: Int = 1)
    {
        layer.borderColor  = color.cgColor
        layer.borderWidth = CGFloat(borderWidth)
    }
    
    func setBlurBackground(child: UIView? = nil, alpha:Float = 1.0)
    {
        if !UIAccessibility.isReduceTransparencyEnabled
        {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bounds
            blurEffectView.alpha = CGFloat(alpha)
            blurEffectView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
            addSubview(blurEffectView)
            if let childView = child
            {
                bringSubviewToFront(childView)
            }
        }
        else
        {
            backgroundColor = UIColor.black
        }
    }
    
    func setShadowToView(cornerRadius:CGFloat = 0, shadowRadius: CGFloat = 2, shadowOpacity: Float = 0.3, shadowColor: UIColor = UIColor.black, shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }

    func setCircleShadowToView(shadowRadius: CGFloat = 2, shadowOpacity: Float = 0.3, shadowColor: UIColor = UIColor.black, shadowOffset: CGSize = CGSize.zero) {
        setShadowToView(cornerRadius: frame.size.height / 2 ,shadowRadius: shadowRadius, shadowOpacity: shadowOpacity, shadowColor: shadowColor, shadowOffset: shadowOffset)
    }
    
    func addSubview(_ controller: UIViewController) {
        if let mainController = parentViewController {
            mainController.addChild(controller)
            addSubview(controller.view)
            controller.didMove(toParent: mainController)
        } else {
            addSubview(controller.view)
        }
    }
    
    @discardableResult
    func bringToFront() -> Bool {
        if let sView = superview {
            sView.bringSubviewToFront(self)
            return true
        }
        return false
    }
    
    @discardableResult
    func sendToBack() -> Bool {
        if let sView = superview {
            sView.sendSubviewToBack(self)
            return true
        }
        return false
    }
}

//Mark: - For Xib -

extension UIView {

    @IBInspectable var isRounded: Bool {
        get { return layer.cornerRadius == frame.size.height * 0.5 }
        set {
            layer.cornerRadius = (newValue ? frame.size.height * 0.5 : 0)
            layer.masksToBounds = true
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor {
        get { return layer.borderColor.map(UIColor.init) ?? UIColor.clear }
        set { layer.borderColor = newValue.cgColor }
    }
}

//Mark: - For Code -

extension UIView {
    var viewController: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}


