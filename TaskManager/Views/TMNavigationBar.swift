//
//  TMNavigationBar.swift
//  TaskManager
//
//  Created by Alireza Asadi on 27/3/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

class TMNavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNavigationBar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let largeTitleAttributes: [NSAttributedString.Key : Any] = [.font : UIFont(name: TMFonts.shabnamBold, size: 36)!,
                                                                    .foregroundColor : UIColor.white]
        let normalTitleAttributes: [NSAttributedString.Key : Any] = [.font : UIFont(name: TMFonts.shabnamMedium, size: 17)!,
                                                                     .foregroundColor : UIColor.white]

        if #available(iOS 11.0, *) {
            self.prefersLargeTitles = true
        }

        self.semanticContentAttribute = .forceRightToLeft

        for subview in self.subviews {
            subview.semanticContentAttribute = .forceRightToLeft
        }

        self.largeTitleTextAttributes = largeTitleAttributes
        self.titleTextAttributes = normalTitleAttributes

        let bgimage = imageWithGradient(startColor: UIColor.red, endColor: UIColor.yellow, size: CGSize(width: UIScreen.main.bounds.size.width, height: 1))
        self.setBackgroundImage(bgimage, for: UIBarMetrics.default)
    }

    private func imageWithGradient(startColor:UIColor, endColor:UIColor, size:CGSize, horizontally:Bool = true) -> UIImage? {

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        if horizontally {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
