//
//  ProfileViewController.swift
//  BlogApp
//
//  Created by 성제 on 2022/03/30.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(didTapSingOut))
    }

    @objc private func didTapSingOut() {
        
    }
}
