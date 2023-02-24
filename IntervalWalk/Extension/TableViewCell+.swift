//
//  TableViewCell+.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib { UINib(nibName: reuseIdentifier, bundle: nil) }
    static var reuseIdentifier: String { String(describing: Self.self) }
}
