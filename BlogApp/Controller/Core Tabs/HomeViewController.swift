//
//  ViewController.swift
//  BlogApp
//
//  Created by 성제 on 2022/03/30.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    private let composeButton : UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.pencil",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 40
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostViewPreViewTableViewCell.self, forCellReuseIdentifier: PostViewPreViewTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(composeButton)
        view.addSubview(tableView)
        composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
//        tableView.dataSource = self
//        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        composeButton.frame = CGRect(x: view.frame.width - 80 - 16, y: view.frame.height - 80 - 16 - view.safeAreaInsets.bottom, width: 60, height: 60)
        tableView.frame = view.bounds
    }
    
    @objc private func didTapCreate() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

