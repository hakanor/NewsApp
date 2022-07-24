//
//  HomeTableViewCell.swift
//  NewsApp
//
//  Created by Hakan Or on 21.07.2022.
//

import Foundation
import UIKit
import CoreData

class HomeTableViewCellViewModel {
    let title: String
    let imageURL: URL?
    var imageData: Data?
    var url: String?
    var urlToImage: String?
    var publishedAt: String
    let description: String?
    var content: String?
    var sourceName: String
    
    init(
        title: String,
        imageURL: URL?,
        url : String?,
        urlToImage: String?,
        publishedAt: String,
        description: String?,
        content: String?,
        sourceName : String
    ) {
        self.title = title
        self.imageURL = imageURL
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.description = description
        self.content = content
        self.sourceName = sourceName
    }
}

class HomeTableViewCell: UITableViewCell {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var model = HomeTableViewCellViewModel(title: "", imageURL: URL(string: ""), url: "", urlToImage: "", publishedAt: "", description: "", content: "", sourceName: "")
    // MARK: - Properties
    private let cornerRadiusValue : CGFloat = 16
    var bookmarkBool : Bool = false
    
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
        articleImage.clipsToBounds = true
        articleImage.layer.cornerRadius = cornerRadiusValue
        articleImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return articleImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = themeColors.blackPrimary
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLabel.text = "Browse"
        titleLabel.contentMode = .scaleToFill
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    private lazy var bookmarkIcon: UIImageView = {
        let bookmarkIcon = UIImageView()
        bookmarkIcon.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bookmark")?.withTintColor(themeColors.greyPrimary)
        bookmarkIcon.image = image
        return bookmarkIcon
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        checkBookmark()
        
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        [articleImage, titleLabel, bookmarkIcon] .forEach(containerView.addSubview(_:))
        
        articleImage.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        articleImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        articleImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        articleImage.heightAnchor.constraint(equalToConstant: 192).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: articleImage.bottomAnchor,constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -20).isActive = true
        
        bookmarkIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20).isActive = true
        bookmarkIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        bookmarkIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        bookmarkIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        bookmarkIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let gestureBookmarkIcon = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGestureBookmark(_:)))
        bookmarkIcon.addGestureRecognizer(gestureBookmarkIcon)
        bookmarkIcon.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = cornerRadiusValue
        containerView.layer.borderColor = themeColors.greyLight.cgColor
        containerView.layer.borderWidth = 0.2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookmarkIcon.image = UIImage(named: "bookmark")?.withTintColor(themeColors.greyPrimary)
    }
    
    // MARK: - Configuration
    @objc func handleTapGestureBookmark(_ sender: UITapGestureRecognizer? = nil) {
        if bookmarkBool == false {
            bookmarkIcon.image = UIImage(named: "bookmark-filled")?.withTintColor(themeColors.purpleLight)
            bookmarkBool = true
            saveToCoreData(with: self.model)
        } else {
            deleteFromCoreData(with: self.model)
            bookmarkIcon.image = UIImage(named: "bookmark")?.withTintColor(themeColors.greyPrimary)
            bookmarkBool = false
        }
        
    }
    
    // no need for that func anymore
    func setHomeTableViewCellLabels(articleImage: UIImage, titleLabel: String){
        self.titleLabel.text = titleLabel
        self.articleImage.image = articleImage
    }
    
    func configureCells(with viewModel: HomeTableViewCellViewModel){
        titleLabel.text = viewModel.title
        self.model = viewModel
        
        if let data = viewModel.imageData {
            articleImage.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url){ data , _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self.articleImage.image = UIImage(data:data)
                }
                
            }.resume()
        }
        
    }
    private func saveToCoreData(with viewModel: HomeTableViewCellViewModel){
        
        if (checkObjectExistInCoreData(title:viewModel.title) == false){
            let newArticle = ArticleEntity(context: self.context)
            newArticle.url = viewModel.url ?? ""
            newArticle.content = viewModel.content
            newArticle.publishedAt = viewModel.publishedAt
            newArticle.urlToImage = viewModel.urlToImage
            newArticle.source = viewModel.sourceName
            newArticle.title = viewModel.title
            newArticle.subtitle = viewModel.description

            do{
                try self.context.save()
            } catch {
                
            }
        }
        
    }
    
//    FIXME: NOT WORKING -- DeleteFromCoreData
    private func deleteFromCoreData(with viewModel : HomeTableViewCellViewModel){
        
        let articleToBeDeleted = ArticleEntity(context: self.context)
        articleToBeDeleted.url = viewModel.url ?? ""
        articleToBeDeleted.content = viewModel.content
        articleToBeDeleted.publishedAt = viewModel.publishedAt
        articleToBeDeleted.urlToImage = viewModel.urlToImage
        articleToBeDeleted.source = viewModel.sourceName
        articleToBeDeleted.title = viewModel.title
        articleToBeDeleted.subtitle = viewModel.description
        self.context.delete(articleToBeDeleted)
        do{
            try context.save()
        } catch {
            
        }
    }
    
    func checkBookmark (){
        if (bookmarkBool == true){
            bookmarkIcon.image = UIImage(named: "bookmark-filled")?.withTintColor(themeColors.purpleLight)
        }
    }
    
    private func checkObjectExistInCoreData(title:String) -> Bool{
        var items : [ArticleEntity]?
        do{
            items = try self.context.fetch(ArticleEntity.fetchRequest())
        } catch {
            
        }
        
        for item in items ?? [] {
            if(item.title == title){
                return true
            }
        }
        return false
    }
}
