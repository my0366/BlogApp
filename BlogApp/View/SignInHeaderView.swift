//
//  SignInHeaderView.swift
//  BlogApp
//
//  Created by 성제 on 2022/04/01.
//

import UIKit

class SignInHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image:  UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Explore millions of articles"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(label)
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size : CGFloat = width / 4
        imageView.frame = CGRect(x: (width-size)/2, y: 10, width: size, height: size)
        label.frame = CGRect(x: 20, y: imageView.bottom+10, width: width-40, height: height-size-30)
    }
}
