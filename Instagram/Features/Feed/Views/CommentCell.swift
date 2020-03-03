//
//  CommentCell.swift
//  Instagram
//
//  Created by Alex Geier on 2/24/20.
//  Copyright © 2020 Alex Geier. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    var username: String? {
        didSet {
            authorLabel.text = username
        }
    }
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    var comment: String? {
        didSet {
            commentLabel.text = comment
        }
    }
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            authorLabel,
            commentLabel,
            UIView()
        ])
        stackView.alignment = .top
        stackView.spacing = 8
        
        addSubview(stackView)
        stackView.edgesToSuperview(insets: .init(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
