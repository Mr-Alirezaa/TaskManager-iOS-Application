//
//  TMButton.swift
//  TaskManager
//
//  Created by Alireza Asadi on 28/2/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

@IBDesignable class TMButton: UIButton {
    
    var style: TMButtonStyle? = .fill
    @IBInspectable private var _styleName: String? {
        didSet {
            style = TMButtonStyle(rawValue: _styleName ?? "fill")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        var titleFontColor = UIColor()
        
        if let style = style {
            switch style {
            case .fill:
                self.backgroundColor = TMColors.lightBlue
                titleFontColor = TMColors.white
            case .outline:
                self.backgroundColor = TMColors.clear
                titleFontColor = TMColors.lightBlue
                self.layer.borderWidth = 2.0
                self.layer.borderColor = TMColors.lightBlue.cgColor
            }
        }
        self.layer.cornerRadius = TMConstants.cornerRadius
        
        self.titleLabel?.font = UIFont(name: TMFonts.shabnamMedium, size: 15)
        self.setTitleColor(titleFontColor, for: .normal)
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
//        setupButton()
    }

}

enum TMButtonStyle: String {
    case fill
    case outline
}
