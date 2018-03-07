//
//  NumuUIButton.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/16/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit

class NumuUIButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    override var isHighlighted: Bool {
        didSet {
            
            if (isHighlighted) {
                self.backgroundColor = UIColor.black
            }
            else {
                self.backgroundColor = UIColor.clear
            }
            
        }
    }

}
