//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by Hakan Or on 16.07.2022.
//

import UIKit
import CoreData

class BookmarksViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        
        
    //    MARK: - Configuration
        func configurateTableView(){
            tableView.dataSource = self
            tableView.delegate = self
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        
    //    MARK: - Functions
    private func fetchArticlesFromCoreData(){
        do{
            self.items = try self.context.fetch(ArticleEntity.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
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
            

            
            tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
            
            tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
            
        }

    }

    //    MARK: - TableView Delegate & TableView DataSource
    extension BookmarksViewController : UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            items?.count ?? 10
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            cell.textLabel?.text = items?[indexPath.row].title
            return cell
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                guard let itemsToBeDeleted = items?[indexPath.row] else { return  }
                print(itemsToBeDeleted)
                context.delete(itemsToBeDeleted)
                items?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                do{
                    try context.save()
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                } catch {
                    
                }

            }
        }
    }
