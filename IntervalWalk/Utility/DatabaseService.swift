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
    
    func getCollection(userId: String?, completion: @escaping ([RecordModel], NSError?) -> Void) {
        var records: [RecordModel] = []
        let uid = userId ?? ""
        db.collection("records").whereField("userId", isEqualTo: uid).getDocuments { (snapshot, error) in
            if let databaseError = error as NSError? {
                completion(records, databaseError)
                return
            }
            
            guard let documents = snapshot?.documents else {
                return
            }
            
            records = documents.compactMap { (queryDocumentSnapshot) -> RecordModel? in
                return try? queryDocumentSnapshot.data(as: RecordModel.self)
            }
            completion(records, nil)
        }
    }
}
