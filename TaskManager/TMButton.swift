//
//  TMButton.swift
//  TaskManager
//
//  Created by Alireza Asadi on 28/2/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

@IBDesignable class TMButton: UIButton {
    
    var style: TMButtonStyle?
    @IBInspectable private var styleName: String? {
        didSet {
            style = TMButtonStyle(rawValue: "styleName")
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
    
    func setupButton() {
        if let style = style {
            switch style {
            case .fill:
                self.backgroundColor = 
            case .outline:
                <#code#>
            }
        }
    }

}

enum TMButtonStyle: String {
    case fill
    case outline
}
