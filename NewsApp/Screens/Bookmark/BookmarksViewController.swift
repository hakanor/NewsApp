//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by Hakan Or on 16.07.2022.
//

import UIKit
import CoreData

class BookmarksViewController: UIViewController {

    //    MARK: - ViewModels
    private var items : [ArticleEntity]?
        
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
        titleLabel.text = "Bookmarks"
        return titleLabel
    }()
        
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = themeColors.greyPrimary
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.text = "Saved articles to the library"
        return subtitleLabel
    }()
        
        
    //    MARK: - Configuration
    func configurateTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
    }
        
    //    MARK: - Functions
    private func fetchArticlesFromCoreData(){
        let coreDataService = CoreDataService()
        coreDataService.fetchArticlesFromCoreData()
        items = coreDataService.items
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
    //    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchArticlesFromCoreData()
        view.backgroundColor = themeColors.white
        [tableView, titleLabel, subtitleLabel] .forEach(view.addSubview(_:))
        configurateTableView()
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        
        tableView.register(BookmarksTableViewCell.self, forCellReuseIdentifier: "BookmarksTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchArticlesFromCoreData()
    }

}

//    MARK: - TableView Delegate & TableView DataSource
extension BookmarksViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items!.count == 0 {
            tableView.setEmptyView(title: "You don't have any bookmarked article.", message: "Your articles will be in here.", messageImage: UIImage(named: "bookmark")!)
            }
            else {
                tableView.restore()
            }
        return items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarksTableViewCell") as! BookmarksTableViewCell
        cell.configureCells(with: (items?[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let itemsToBeDeleted = items?[indexPath.row] else { return  }
            items?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let coreDataService = CoreDataService()
            coreDataService.deleteFromCoreData(with: itemsToBeDeleted)
            DispatchQueue.main.async {
                tableView.reloadData()
            }

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items![indexPath.row]
        let vc = ArticleViewController(
            title: item.title ?? "",
            source: item.source ?? "",
            content: item.content ?? "",
            imageUrl: item.urlToImage ?? "",
            url: item.url ?? ""
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
