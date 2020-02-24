//
//  Button.swift
//  Instagram
//
//  Created by Alex Geier on 2/23/20.
//  Copyright © 2020 Alex Geier. All rights reserved.
//

import UIKit

class Button: UIButton {
    var _backgroundColor: UIColor
    
    init(backgroundColor: UIColor) {
        _backgroundColor = backgroundColor
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? _backgroundColor.withAlphaComponent(0.8) : _backgroundColor
        }
    }
}
