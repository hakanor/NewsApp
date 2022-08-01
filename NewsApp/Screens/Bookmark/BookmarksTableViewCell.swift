//
//  BookmarksTableViewCell.swift
//  NewsApp
//
//  Created by Hakan Or on 26.07.2022.
//

import Foundation
import UIKit

class BookmarksTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let cornerRadiusValue : CGFloat = 16
    
    // MARK: - Subviews
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeColors.white
        return view
    }()
    
    private lazy var articleImage: UIImageView = {
        let articleImage = UIImageView()
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bookmark")
        articleImage.image = image
        articleImage.contentMode = .scaleAspectFill
        articleImage.backgroundColor = themeColors.white
        articleImage.clipsToBounds = true
        articleImage.layer.cornerRadius = cornerRadiusValue
        return articleImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = themeColors.greyPrimary
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.text = "UI/UX Design"
        titleLabel.contentMode = .scaleToFill
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = themeColors.blackPrimary
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        subtitleLabel.text = "A Simple Trick For creating Color Palettes Quickly"
        subtitleLabel.contentMode = .scaleToFill
        subtitleLabel.numberOfLines = 2
        return subtitleLabel
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        [titleLabel, subtitleLabel , articleImage] .forEach(containerView.addSubview(_:))

        articleImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        articleImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        articleImage.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        articleImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        articleImage.heightAnchor.constraint(equalToConstant: 96).isActive = true
        articleImage.widthAnchor.constraint(equalToConstant: 96).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor,constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -19).isActive = true

        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor,constant: 16).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -12).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        subtitleLabel.text = ""
        articleImage.image = nil
    }
    
    // MARK: - Configuration
    func configureCells(with articleEntity: ArticleEntity){
        titleLabel.text = articleEntity.title
        subtitleLabel.text = articleEntity.subtitle
        articleImage.imageFromUrl(from: articleEntity.urlToImage!,contentMode: .scaleAspectFill)
    }
    
}
