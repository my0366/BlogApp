//
//  CreateNewPostViewController.swift
//  BlogApp
//
//  Created by 성제 on 2022/03/30.
//

import UIKit

class CreateNewPostViewController: UITabBarController {
    
    //Title
    private let titleField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "Enter Title..."
        field.autocapitalizationType = .none
        field.autocorrectionType = .yes
        field.layer.masksToBounds = true
        return field
    }()
    //Image Header
    private let headerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    //TextView for Post
    private let textView : UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.font = .systemFont(ofSize : 28)
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerImageView)
        view.addSubview(textView)
        view.addSubview(titleField)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
        configureButtons()
    }
    
    private var selectedHeaderImage : UIImage?
    override func viewDidLayoutSubviews() {
        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width-20, height: 50)
        headerImageView.frame = CGRect(x: 0, y: titleField.bottom + 6, width: view.width, height: 160)
        textView.frame = CGRect(x: 10, y: headerImageView.bottom + 10, width: view.width-20, height: view.height-210-view.safeAreaInsets.top)
    }
    
    @objc private func didTapHeader() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapPost() {
        guard let title = titleField.text,
              let body = textView.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            let alert = UIAlertController(title: "Enter Post Details", message: "Please enter a title, body and select a Image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        print("Staring Post...")
        let newPostID = UUID().uuidString
        // Upload
        StorageManager.shared.uploadBlogHeaderImage(email: email, image: headerImage, postId: newPostID)
        { success in
            guard success else {
                return
            }
            StorageManager.shared.downloadPicturePostHeader(email: email, postId: newPostID) { url in
                guard let headerURL = url else {
                    print("A")
                    return
                }
                
                let post = BlogPost(identifier: newPostID, title: title, timestemp: Date().timeIntervalSince1970, headerImageUrl: headerURL, text: body)
                
                DataBase.shared.insertBlogPost(blogpost: post, user: email) { [weak self] posted in
                    guard posted else {
                        print("Failed to post on blog")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        print("A")
                        self?.didTapCancel()
                    }
                }
            }
        }
    }
}

extension CreateNewPostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        selectedHeaderImage = image
        headerImageView.image = image
    }
}
