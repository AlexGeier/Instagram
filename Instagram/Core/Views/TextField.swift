//
//  TextField.swift
//  Instagram
//
//  Created by Alex Geier on 2/23/20.
//  Copyright © 2020 Alex Geier. All rights reserved.
//

import UIKit

class TextField: UITextField {
    let padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)

    init() {
        super.init(frame: .zero)
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 8
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
