//
//  NumuModalButton.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/20/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class NumuModalButton: UIButton {

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 1, green: 1, blue: 1, alpha: 0.1) : UIColor.clear
        }
    }

}
