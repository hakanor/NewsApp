//
//  ProfileViewController.swift
//  NewsApp
//
//  Created by Hakan Or on 16.07.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Properties
    var sectionContents = [0: ["Notifications","Language","Change Password"],
                              1: ["Privacy","Terms & Conditions"],
                              2: ["Sign Out"]]
    
            
    // MARK: - Subviews
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
        titleLabel.text = "Profile"
        return titleLabel
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeColors.white
        return view
    }()
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "profile")
        profileImage.image = image
        profileImage.contentMode = .scaleAspectFill
        profileImage.backgroundColor = themeColors.white
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 35
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = themeColors.blackPrimary.cgColor
        return profileImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = themeColors.blackPrimary
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.text = "John Doe"
        nameLabel.contentMode = .scaleToFill
        nameLabel.numberOfLines = 1
        return nameLabel
    }()
    
    private lazy var mailLabel: UILabel = {
        let mailLabel = UILabel()
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        mailLabel.textColor = themeColors.greyPrimary
        mailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        mailLabel.text = "johndoe@gmail.com"
        mailLabel.contentMode = .scaleToFill
        mailLabel.numberOfLines = 1
        return mailLabel
    }()
    
    //    MARK: - Configuration
    func configurateTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    //    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColors.white
        [tableView, titleLabel , containerView] .forEach(view.addSubview(_:))
        configurateTableView()
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        
        containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 32).isActive = true
        containerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        [profileImage ,nameLabel, mailLabel] .forEach(containerView.addSubview(_:))
        
        profileImage.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 72).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 72).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true

        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 24).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        mailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -10).isActive = true
        mailLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 24).isActive = true
        mailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        mailLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        
    }

}

//    MARK: - TableView Delegate & TableView DataSource
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else if section == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section:Int = indexPath.section
        let row:Int = indexPath.row
        var imageName = "angle-right"
        if(sectionContents[section]?[row] == "Sign Out"){
            imageName = "signout"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        cell.configureCells(title: sectionContents[section]?[row] ?? "" , imageName: imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionContents.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 4
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        6
    }
}
