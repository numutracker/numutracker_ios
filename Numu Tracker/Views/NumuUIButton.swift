//
//  NumuUIButton.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/16/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit

class NumuUIButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? .selectedCell : .numuBlue
        }
    }

    func setup() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        self.backgroundColor = .numuBlue
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
    }

}
