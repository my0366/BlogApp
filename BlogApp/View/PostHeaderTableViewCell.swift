//
//  PostViewHeaderTableViewCell.swift
//  BlogApp
//
//  Created by 성제 on 2022/04/06.
//

import UIKit

class PostHeaderTableViewCellViewModel {
    let imageURL : URL?
    var imageData : Data?
    
    init(imageURL : URL?) {
        self.imageURL = imageURL
    }
}
class PostHeaderTableViewCell: UITableViewCell {
    static let identifier = "PostHeaderTableViewCell"
    
    private let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
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
    }
    
    required init?(coder : NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
    func configure(with viewModel : PostHeaderTableViewCellViewModel) {
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }

}
