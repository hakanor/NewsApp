//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Hakan Or on 16.07.2022.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {

//    MARK: - ViewModels
    private var viewModels = [HomeTableViewCellViewModel]()
    private var articles = [Article]()
    
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
        textField.rightImage(UIImage(named: "microphone")?.withTintColor(themeColors.blackDarker), imageWidth: 56, padding: 8)
        textField.layer.cornerRadius = 10
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
                        imageURL: URL(string: $0.urlToImage ?? "")
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url:url)
        present(vc,animated: true)
    }
}
