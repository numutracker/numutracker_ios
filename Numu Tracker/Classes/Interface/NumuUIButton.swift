//
//  NumuUIButton.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/16/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit

class NumuUIButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? .black : .clear
        }
    }

}
