//
//  AuthManager.swift
//  BlogApp
//
//  Created by 성제 on 2022/03/30.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private init () {}
    
    public var isSigneedIn: Bool {
        return auth.currentUser != nil
        
    }
    public func singUp(email:String, password:String, completion : @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        auth.createUser(withEmail: email, password: password) { result,error in
            completion(true)
            return
        }
        
        completion(true)
    }
    
    public func singIn(email:String, password:String, completion : @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        auth.signIn(withEmail: email, password: password) { result,error in
            completion(false)
            return
        }
        completion(true)
    }
    
    public func singOut(completion : @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
}
