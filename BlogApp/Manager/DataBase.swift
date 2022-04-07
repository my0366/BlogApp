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
        user : String,
        completion : @escaping (Bool) -> Void
    ) {
        let userEmail = user.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
        let data : [String:Any] = ["id": blogpost.identifier,
                                   "title" : blogpost.title,
                                   "body" : blogpost.text,
                                   "created" : blogpost.timestemp,
                                   "headerImage":blogpost.headerImageUrl?.absoluteString ?? ""]
        
        database.collection("users").document(userEmail).collection("posts").document(blogpost.identifier).setData(data) { error in
            completion(error == nil)
        }
    }
    
    public func getAllPosts(
        completion : @escaping ([BlogPost]) -> Void
    ) {
        
    }
    
    public func getPosts(
        for user:String,
        completion : @escaping ([BlogPost]) -> Void
    ) {
        let userEmail = user.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
        database.collection("users").document(userEmail).collection("posts").getDocuments { snapShot, error in
            guard let documents = snapShot?.documents.compactMap({ $0.data() }),
            error == nil else {
                return
            }
            
            let posts : [BlogPost] = documents.compactMap ({ dictionary in
                guard let id = dictionary["id"] as? String,
                      let title = dictionary["title"] as? String,
                      let body = dictionary["body"] as? String,
                      let timeStemp = dictionary["created"] as? TimeInterval,
                      let headerImage = dictionary["headerImage"] as? String else {
                    print("Invaild post fetch conversion")
                    return nil
                }
                      
                let post = BlogPost(identifier: id, title: title, timestemp: timeStemp, headerImageUrl: URL(string: headerImage), text: body)
                return post
            })
            completion(posts)
        }
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
    
    public func getUser(email : String, completion: @escaping (User?) -> Void) {
        let documentId = email.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
        
        database.collection("users").document(documentId).getDocument { snapshot, error in
            guard let data = snapshot?.data() as? [String: String],
                  let name = data["name"],
                  error == nil else {
                return
            }
            
            var ref = data["profile_photo"]
            
            let user = User(name: name, email: email, profilePicture: ref)
            completion(user)
        }
        
    }
    func uploadPhoto(email : String, completon : @escaping (Bool) -> Void) {
        let path = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        let photoRef = "profile_pictures/\(path)/photo.png"
        
        let dbRef = database.collection("users").document(path)
        
        dbRef.getDocument { snapShot, error in
            guard var data = snapShot?.data(), error == nil else {
                return
            }
            data["profile_photo"] = photoRef
            
            dbRef.setData(data) { error in
                completon(error == nil)
            }
        }
    }
    
}

