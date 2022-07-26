//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Hakan Or on 16.07.2022.
//

import UIKit

class HomeViewController: UIViewController {

//    MARK: - ViewModels
    private var viewModels = [HomeTableViewCellViewModel]()
    private var articles = [Article]()
    private var items : [ArticleEntity]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = themeColors.blackPrimary
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.text = "Browse"
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = themeColors.greyPrimary
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.text = "Discover things of this world"
        return subtitleLabel
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.blackDarker.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textField.backgroundColor = themeColors.purpleLighter
        textField.leftImage(UIImage(named: "search")?.withTintColor(themeColors.blackDarker), imageWidth: 56, padding: 8)
//        textField.rightImage(UIImage(named: "times")?.withTintColor(themeColors.blackDarker), imageWidth: 56, padding: 8)
//        FIXME: ADD "searchFunc" to textfield.rightButton
        textField.rightButton(UIImage(named: "times")?.withTintColor(themeColors.blackDarker), imageWidth: 56, padding: 8)
        textField.layer.cornerRadius = 10
        textField.addTarget(self, action: #selector(searchFunc), for: .editingDidEndOnExit)
        return textField
       }()
    
//    MARK: - Configuration
    func configurateTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0   )
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFunc), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
//    MARK: - Functions
    private func fetchNews(){
        let service = NewsService()
        service.fetchNewsData { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    HomeTableViewCellViewModel(
                        title: $0.title,
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        url : $0.url!,
                        urlToImage: $0.urlToImage,
                        publishedAt: $0.publishedAt,
                        description: $0.description,
                        content: $0.content,
                        sourceName : $0.source.name
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    private func search(){
        let service = NewsService()
        service.search(with: textField.text!) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    HomeTableViewCellViewModel(
                        title: $0.title,
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        url : $0.url!,
                        urlToImage: $0.urlToImage,
                        publishedAt: $0.publishedAt,
                        description: $0.description,
                        content: $0.content,
                        sourceName : $0.source.name
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func refreshFunc(refreshControl: UIRefreshControl) {
        fetchNews()
        refreshControl.endRefreshing()
    }
    
    @objc func searchFunc() {
        search()
    }
    
    private func fetchArticlesFromCoreData(){
        let coreDataService = CoreDataService()
        coreDataService.fetchArticlesFromCoreData()
        items = coreDataService.items
    }
    
    private func isArticleBookmarked(title:String) -> Bool {
        for item in items ?? [] {
            if (item.title == title){
                return true
            }
        }
        return false
    }
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColors.white
        [tableView, titleLabel, subtitleLabel, textField] .forEach(view.addSubview(_:))
        configurateTableView()
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        textField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        
        fetchNews()
        fetchArticlesFromCoreData()
        
    }

}

//    MARK: - TableView Delegate & TableView DataSource
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.configureCells(with: viewModels[indexPath.row])
        if(isArticleBookmarked(title: viewModels[indexPath.row].title)){
            cell.bookmarkBool = true
            cell.checkBookmark()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        let vc = ArticleViewController(
            title: article.title,
            source: article.source.name,
            content: article.content ?? "",
            imageUrl: article.urlToImage ?? "",
            url: article.url ?? ""
        )
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
