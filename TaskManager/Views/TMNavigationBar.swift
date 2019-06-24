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
                                                                    .foregroundColor : TMColors.lightBlue]
        let normalTitleAttributes: [NSAttributedString.Key : Any] = [.font : UIFont(name: TMFonts.shabnamBold, size: 18)!,
                                                                     .foregroundColor : UIColor.white]

        if #available(iOS 11.0, *) {
            self.prefersLargeTitles = false
        }

        self.semanticContentAttribute = .forceRightToLeft

        for subview in self.subviews {
            subview.semanticContentAttribute = .forceRightToLeft
        }

        self.largeTitleTextAttributes = largeTitleAttributes
        self.titleTextAttributes = normalTitleAttributes

    }
}
