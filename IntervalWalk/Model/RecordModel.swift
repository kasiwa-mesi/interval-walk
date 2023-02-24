//
//  RecordModel.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import Foundation
import FirebaseFirestoreSwift

struct RecordModel: Codable {
    @DocumentID var id: String?
    var hour: Int
    var minute: Int
    var second: Int
    var userId: String
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case hour
        case minute
        case second
        case userId
        case createdAt
    }
}
