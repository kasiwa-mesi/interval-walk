//
//  TableViewCell.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import UIKit
import SwiftDate

class TableViewCell: UITableViewCell {
    
    @IBOutlet private weak var recordCreatedAt: UILabel!
    @IBOutlet private weak var recordTimeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recordCreatedAt.text = nil
        recordTimeLabel.text = nil
    }
    
    func configure(record: RecordModel) {
        recordTimeLabel.text = "歩いた時間: \(record.hour)時間\(record.minute)分\(record.second)秒"
        let createdAt = "\(record.createdAt.year)年\(record.createdAt.month)月\(record.createdAt.day)日"
        recordCreatedAt.text = createdAt
    }
}
