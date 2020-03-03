//
//  AddCommentCell.swift
//  Instagram
//
//  Created by Alex Geier on 3/2/20.
//  Copyright © 2020 Alex Geier. All rights reserved.
//

import UIKit

class AddCommentCell: UITableViewCell {
    private let addCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a comment..."
        label.textColor = .systemGray
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(addCommentLabel)
        addCommentLabel.edgesToSuperview(excluding: .trailing, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
    }
}
