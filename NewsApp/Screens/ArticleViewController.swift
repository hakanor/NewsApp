//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by Hakan Or on 22.07.2022.
//

import UIKit
import SafariServices

class ArticleViewController: UIViewController {
    
    private var contentURL = ""
    
//    MARK: - Subviews
    private lazy var articleImage: UIImageView = {
        let articleImage = UIImageView()
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "kedi")
        articleImage.image = image
        articleImage.contentMode = .scaleAspectFill
        articleImage.clipsToBounds = true
        return articleImage
    }()
    
    private lazy var backIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "arrow-left")?.withTintColor(.white)
        icon.image = image
        icon.clipsToBounds = true
        return icon
    }()
    
    private lazy var bookmarkIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bookmark")?.withTintColor(.white)
        icon.image = image
        icon.clipsToBounds = true
        return icon
    }()
    
    private lazy var shareIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "share")?.withTintColor(.white)
        icon.image = image
        icon.clipsToBounds = true
        return icon
    }()
    
    private lazy var sourceLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = themeColors.white
        subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        subtitleLabel.text = "US Election"
        return subtitleLabel
    }()
    
    private lazy var sourceLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeColors.purplePrimary
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = themeColors.white
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = "The latest situation in the presidential election"
        return titleLabel
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layer.cornerRadius = 16
        scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        scrollView.backgroundColor = themeColors.white
        return scrollView
    }()
    
    private lazy var scrollContent: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = themeColors.greyDarker
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam hendrerit purus a massa condimentum consequat in eu turpis. Donec maximus ipsum id luctus dictum. Fusce eu arcu mi. Nulla ullamcorper lectus ut ipsum semper, eu posuere odio porttitor. Suspendisse accumsan tellus et dui luctus, et feugiat quam suscipit. Praesent ligula dui, efficitur eu elementum vitae, vehicula tincidunt risus. Quisque faucibus sapien vitae iaculis aliquam. Maecenas felis elit, dapibus vitae suscipit non, commodo ut lorem. Vivamus facilisis, sapien vitae porttitor ullamcorper, ligula ante facilisis augue, id hendrerit erat justo in elit. Nunc imperdiet at quam sed sollicitudin."
        return titleLabel
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColors.white
        
        let gestureSource = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGestureSource(_:)))
        sourceLabelContainer.addGestureRecognizer(gestureSource)
        
        [articleImage, backIcon, bookmarkIcon, shareIcon ,sourceLabel ,sourceLabelContainer, titleLabel, scrollView] .forEach(view.addSubview(_:))
        
        articleImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        articleImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        articleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        articleImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        
        backIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 24).isActive = true
        backIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        backIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        bookmarkIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 24).isActive = true
        bookmarkIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        bookmarkIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        bookmarkIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        shareIcon.topAnchor.constraint(equalTo: bookmarkIcon.bottomAnchor,constant: 24).isActive = true
        shareIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        shareIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        shareIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: articleImage.bottomAnchor,constant: -40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        sourceLabelContainer.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16).isActive = true
        sourceLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        sourceLabelContainer.addSubview(sourceLabel)
        sourceLabel.topAnchor.constraint(equalTo: sourceLabelContainer.topAnchor, constant: 8).isActive = true
        sourceLabel.bottomAnchor.constraint(equalTo: sourceLabelContainer.bottomAnchor,constant: -8).isActive = true
        sourceLabel.leadingAnchor.constraint(equalTo: sourceLabelContainer.leadingAnchor, constant: 16).isActive = true
        sourceLabel.trailingAnchor.constraint(equalTo: sourceLabelContainer.trailingAnchor, constant: -16).isActive = true

        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.47).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        scrollView.addSubview(scrollContent)
        scrollContent.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        scrollContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 20).isActive = true
        scrollContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: -20).isActive = true
        scrollContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,constant: -10).isActive = true
        scrollContent.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        
    }
    
    @objc func handleTapGestureSource(_ sender: UITapGestureRecognizer? = nil) {
        guard let url = URL(string: self.contentURL ) else {
            return
        }
        let vc = SFSafariViewController(url:url)
        present(vc,animated: true)
    }
    
    init(title:String, source:String, content:String, imageUrl:String , url:String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.sourceLabel.text = source
        self.scrollContent.text = content
        self.articleImage.imageFromUrl(from: imageUrl,contentMode: .scaleAspectFill)
        self.contentURL = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
