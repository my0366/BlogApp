//
//  ProfileViewController.swift
//  BlogApp
//
//  Created by 성제 on 2022/03/30.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpSignOutButton()
        setUpTable()
        title = currentEmail
        title = "Profile"
        fetchPost()
    }
    
    private var user : User?
    let currentEmail : String
    
    init(currentEmail : String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder : NSCoder) {
        fatalError()
    }
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostViewPreViewTableViewCell.self, forCellReuseIdentifier: PostViewPreViewTableViewCell.identifier)
        return tableView
    }()
    
    private func setUpSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(didTapSignOut))
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableHeader ()
        fetchProfileData()
    }
    
    private func setUpTableHeader(profilePhotoURL : String? = nil , name : String? = nil) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/3))
        headerView.backgroundColor = .systemBlue
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        
        let profilePhoto = UIImageView(image : UIImage(systemName: "person.circle"))
        profilePhoto.tintColor = .white
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.frame = CGRect(x: (view.width - (view.width/4))/2, y: (headerView.height - (view.width/4))/2.5, width: view.width/4, height: view.width/3.5)
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.width / 2
        profilePhoto.isUserInteractionEnabled = true
        headerView.addSubview(profilePhoto)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)
        
        // Email
        let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePhoto.bottom + 10, width: view.width-40, height: 100))
        headerView.addSubview(emailLabel)
        emailLabel.text = currentEmail
        emailLabel.textColor = .white
        emailLabel.font = .systemFont(ofSize: 25, weight: .bold)
        
        if let name = name {
            title = name
        }
        
        if let ref = profilePhotoURL {
            print("Found photo ref : \(ref)")
            StorageManager.shared.downloadPicture(path: ref) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
    }
    
    @objc private func didTapProfilePhoto() {
        
        guard let myEmail = UserDefaults.standard.string(forKey: "email"), myEmail == currentEmail else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func fetchProfileData() {
        DataBase.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user
            DispatchQueue.main.async {
                self?.setUpTableHeader(profilePhotoURL: user.profilePicture, name: user.name)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc private func didTapSignOut() {
        let sheet = UIAlertController(title: "Sign Out", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        let signInVC = SignInViewController()
                        signInVC.navigationItem.largeTitleDisplayMode = .always
                        let navVC = UINavigationController(rootViewController: signInVC)
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(sheet, animated: true)
    }
    
    //TableView
    private var posts:[BlogPost] = []
    
    private func fetchPost() {
        print("Fetching Data...")
        DataBase.shared.getPosts(for: currentEmail) { [weak self]posts in
            self?.posts = posts
            print(posts.count)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostViewPreViewTableViewCell.identifier, for: indexPath) as? PostViewPreViewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageURL: post.headerImageUrl))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) { [weak self]success in
            guard let strongSelf = self else { return }
            if success {
                //Update
                DataBase.shared.uploadPhoto(email : strongSelf.currentEmail) { update in
                    guard update else {
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                }
            }
        }
    }
}
