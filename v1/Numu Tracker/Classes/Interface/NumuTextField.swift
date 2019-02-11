//
//  NumuTextField.swift
//  Numu Tracker
//
//  Created by Bradley Root on 9/5/17.
//  Copyright © 2017 Numu Tracker. All rights reserved.
//

import UIKit

class NumuTextField: UITextField {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        self.borderStyle = .none

        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.textColor = .white

        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red: 0.24, green: 0.67, blue: 0.73, alpha: 1.0).cgColor
        border.frame = CGRect(
            x: 0,
            y: self.frame.size.height - width + 0,
            width: self.frame.size.width + 100,
            height: self.frame.size.height)

        border.borderWidth = width
        print(self.frame.size.height)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }

}
