//
//  TMTextField.swift
//  TaskManager
//
//  Created by Alireza Asadi on 28/2/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

@IBDesignable
class TMTextField: UITextField {
    
    enum TMTextFieldStyle: String {
        case first
        case last
        case middle
    }
    
    var textFieldStyle: TMTextFieldStyle?
    
    @IBInspectable
    private var _textFieldStyle: String = "middle" {
        didSet {
            textFieldStyle = TMTextFieldStyle(rawValue: _textFieldStyle)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    private func setupTextField() {
        self.layer.borderColor = TMColors.black.cgColor
        
        self.font = UIFont(name: TMFonts.shabnamLight, size: 15)
        self.textAlignment = NSTextAlignment.right
        
        setNeedsDisplay()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
//        setupTextField()
    }
    
    private let placeholderPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: placeholderPadding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: placeholderPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: placeholderPadding)
    }
    
    override func draw(_ rect: CGRect) {
        //// Rectangle Drawing
        var roundingCorners = UIRectCorner()
        if let textFieldStyle = textFieldStyle {
            switch textFieldStyle {
                case .first:
                    roundingCorners = [.topLeft, .topRight]
                case .last:
                    roundingCorners = [.bottomLeft, .bottomRight]
                default:
                    roundingCorners = []
            }
        }
        let rectanglePath = UIBezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: TMConstants.cornerRadius, height: TMConstants.cornerRadius))
        rectanglePath.lineWidth = 0.3
        rectanglePath.close()
        TMColors.white.setFill()
        TMColors.black.withAlphaComponent(0.5).setStroke()
        rectanglePath.fill()
        rectanglePath.stroke()
    }
}

