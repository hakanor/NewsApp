//
//  ProfileTableViewCell.swift
//  NewsApp
//
//  Created by Hakan Or on 28.07.2022.
//

import Foundation
import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let cornerRadiusValue : CGFloat = 16
    
    // MARK: - Subviews
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeColors.greyLighter
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private lazy var labelImage: UIImageView = {
        let labelImage = UIImageView()
        labelImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "angle-right")
        labelImage.image = image
        labelImage.contentMode = .scaleAspectFit
        labelImage.backgroundColor = .clear
        labelImage.clipsToBounds = true
        return labelImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = themeColors.blackPrimary
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.text = "UI/UX Design"
        titleLabel.contentMode = .scaleToFill
        titleLabel.numberOfLines = 1
        return titleLabel
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
        
        [titleLabel , labelImage] .forEach(containerView.addSubview(_:))

        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 24).isActive = true
  
        labelImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        labelImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        labelImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -6).isActive = true
        
        labelImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        labelImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Configuration
    func configureCells(with articleEntity: ArticleEntity){
        
    }
    
}
