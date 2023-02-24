//
//  DatabaseService.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DatabaseService {
    static let shared: DatabaseService = .init()
    private init() {}
    
    private var db = Firestore.firestore()
    
    func addRecord(hour: Int, minute: Int, second: Int, userId: String, completion: @escaping (NSError?) -> Void) {
        db.collection("records").addDocument(data: [
            "hour": hour,
            "minute": minute,
            "second": second,
            "userId": userId,
            "createdAt": FirebaseFirestore.FieldValue.serverTimestamp(),
        ]) { error in
            if let databaseError = error as NSError? {
                completion(databaseError)
                return
            }
            completion(nil)
        }
    }
}
