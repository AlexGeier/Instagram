//
//  PostCell.swift
//  Instagram
//
//  Created by Alex Geier on 2/23/20.
//  Copyright © 2020 Alex Geier. All rights reserved.
//

import UIKit
import SDWebImage

class PostCell: UITableViewCell {
    var imageURL: URL? {
        didSet {
            postImageView.sd_setImage(with: imageURL, completed: nil)
        }
    }
    
    var author: String? {
        didSet {
            authorLabel.text = author
        }
    }
    
    var caption: String? {
        didSet {
            captionLabel.text = caption
        }
    }
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    private func setupLayout() {
        let textStackView = UIStackView(arrangedSubviews: [
            authorLabel,
            captionLabel,
            UIView()
        ])
        textStackView.alignment = .top
        textStackView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [
            postImageView,
            textStackView,
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        postImageView.aspectRatio(1)
        
        addSubview(stackView)
        stackView.edgesToSuperview(insets: .init(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
