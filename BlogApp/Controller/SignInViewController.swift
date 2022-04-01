//
//  SingInViewController.swift
//  BlogApp
//
//  Created by 성제 on 2022/03/30.
//

import UIKit

class SignInViewController: UITabBarController {
    
    // Header View
    private let headerView = SignInHeaderView()
    // Email Field
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "Email Address"
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    // Password field
    private let passwordField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    // SignIn Button
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    // Creage Account
    private let createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Create Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createButton)
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/4)
//
//        emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.widthAnchor-40, height: 50)
//        emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
//        emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
//        emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
    }
    
    
    @objc func didTapSignIn() {
        
    }
    
    @objc func didTapCreate() {
        
    }

}
