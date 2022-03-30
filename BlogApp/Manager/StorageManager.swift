//
//  StorageManager.swift
//  BlogApp
//
//  Created by 성제 on 2022/03/30.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage().reference()
    
    private init () {}
    
    public func uploadUserProfilePicture(
        email:String,
        image:UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
    }
    
    public func downloadPicture(
        user:User,
        completion: @escaping (URL?) -> Void
    ) {
        
    }
    
    public func uploadBlogHeaderImage(
        image:UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
    }
    
    public func downloadPicturePostHeader(
        blogPost : BlogPost,
        completion: @escaping (URL?) -> Void
    ) {
        
    }
}
