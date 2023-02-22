//
//  AuthService.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/19.
//

import Foundation
import FirebaseAuth

final class AuthService {
    static let shared: AuthService = .init()
    private init() {}
    
    func getCurrentUser() -> User? { Auth.auth().currentUser }
    
    func getCurrentUserEmail() -> String? { Auth.auth().currentUser?.email }
    
    func setLanguageCode(code: String) {
        Auth.auth().languageCode = code
    }
    
    func isLogined(completionHandler: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener({ auth, user in
            completionHandler(user != nil)
        })
    }
    
    func createUser(email: String, password: String, completionHandler: @escaping (NSError?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authError = error as NSError? {
                completionHandler(authError)
                return
            }
            completionHandler(nil)
        }
    }
    
    func sendEmailVerification(completionHandler: @escaping (NSError?) -> Void) {
        let user = getCurrentUser()
        // メールが送れなかった場合のエラーハンドリングを記述
        user?.sendEmailVerification { error in
            if let authError = error as NSError? {
                completionHandler(authError)
                return
            }
            completionHandler(nil)
        }
    }
    
    func signIn(email: String, password: String, completionHandler: @escaping (NSError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let authError = error as NSError? {
                completionHandler(authError)
                return
            }
            completionHandler(nil)
        }
    }
    
    func sendPasswordReset(email: String, completionHandler: @escaping (NSError?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let authError = error as NSError? {
                completionHandler(authError)
                return
            }
            completionHandler(nil)
        }
    }
}
