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
    
    func createUser(email: String, password: String, completionHandler: @escaping (NSError?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authError = error as NSError? {
                completionHandler(authError)
                return
            }
            completionHandler(nil)
        }
    }
}
