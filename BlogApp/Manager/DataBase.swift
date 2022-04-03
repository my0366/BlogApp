//
//  DataBase.swift
//  BlogApp
//
//  Created by 성제 on 2022/03/30.
//

import Foundation
import FirebaseFirestore
import Firebase
final class DataBase {
    static let shared = DataBase()
    
    private let database = Firestore.firestore()
    private init () {}
    
    public func insertBlogPost(
        blogpost : BlogPost,
        user : User,
        completion : @escaping (Bool) -> Void
    ) {
        
    }
    
    public func getAllPosts(
        completion : @escaping ([BlogPost]) -> Void
    ) {
        
    }
    
    public func getPosts(
        for user:User,
        completion : @escaping ([BlogPost]) -> Void
    ) {
        
    }
    
    public func insertUser(
        user : User,
        completion : @escaping (Bool) -> Void
    ) {
        let documentId = user.email.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
        let data = ["name" : user.name, "email" : user.email]
        database.collection("users").document(documentId).setData(data) { error in
            completion(error == nil)
        }
    }
    
}

