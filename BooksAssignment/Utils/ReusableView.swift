//
//  ReusableView.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import UIKit

protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
