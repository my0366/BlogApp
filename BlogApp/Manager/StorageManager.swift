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
    
    private let container = Storage.storage()
    
    private init () {}
    
    public func uploadUserProfilePicture(
        email:String,
        image:UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        guard let pngData = image?.pngData() else {
            return
        }
        container.reference(withPath: "profile_pictures/\(path)/photo.png").putData(pngData,metadata: nil) { metaData, error in
            guard metaData != nil, error == nil else{
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func downloadPicture(
        path:String,
        completion: @escaping (URL?) -> Void
    ) {
        container.reference(withPath: path).downloadURL { url, _ in
            completion(url)
        }
    }
    
    public func uploadBlogHeaderImage(
        email: String,
        image:UIImage,
        postId: String,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        guard let pngData = image.pngData() else {
            return
        }
        container.reference(withPath: "post_header/\(path)/\(postId).png").putData(pngData,metadata: nil) { metaData, error in
            guard metaData != nil, error == nil else{
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func downloadPicturePostHeader(
        email:String,
        postId : String,
        completion: @escaping (URL?) -> Void
    ) {
        let emailComponent = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        container.reference(withPath: "profile_pictures/\(emailComponent)/\(postId)photo.png").downloadURL { url, _ in
            completion(url)
        }
    }
}
