//
//  ViewController.swift
//  NewsApp
//
//  Created by Hakan Or on 15.07.2022.
//

import UIKit

class MainViewController: UITabBarController {
    
//    MARK: - Tabbar View Controllers
    
    let homeVC = UINavigationController(rootViewController: HomeViewController())
    let bookmarksVC = UINavigationController(rootViewController: BookmarksViewController())
    let profileVC = UINavigationController(rootViewController: ProfileViewController())
    
//    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([homeVC,bookmarksVC,profileVC], animated: true)
        setTabbarItems()
    }
    
//    MARK: - Configuration
    func setTabbarItems(){
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        bookmarksVC.tabBarItem.image = UIImage(systemName: "house")
        profileVC.tabBarItem.image = UIImage(systemName: "house")
        tabBar.isTranslucent = true
        tabBar.tintColor = .label
    }

}

