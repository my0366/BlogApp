//
//  PostViewTableViewCell.swift
//  BlogApp
//
//  Created by 성제 on 2022/04/06.
//

import UIKit

class PostViewTableViewCellModel {
    let title:String
    let imageURL:URL?
    var imageData : Data?
    
    init(title:String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
}
class PostViewPreViewTableViewCell: UITableViewCell {
    
    static let identifier = "PostViewPreViewTableViewCell"
    
    private let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let postTitleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize:20, weight: .medium)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
        contentView.addSubview(postTitleLabel)
    }
    
    required init?(coder : NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = CGRect(x: separatorInset.left, y: 5, width: contentView.height - 10, height: contentView.height - 10)
        
        postTitleLabel.frame = CGRect(x: postImageView.right+5, y: 5, width: contentView.width-5-separatorInset.left-postImageView.width, height: contentView.height-10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
    }
    
    func configure(with model: PostViewTableViewCellModel) {
        postTitleLabel.text =  model.title
        
        if let data = model.imageData {
            postImageView.image = UIImage(data: data)
        } else if let url = model.imageURL {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else {
                    return
                }
                model.imageData = data
                DispatchQueue.main.async {
                    self.postImageView.image = UIImage(data: data)
                }
            }
            task.resume() 
        }
    }
}
