//
//  NibLoadableView.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import UIKit

protocol NibLoadableView: AnyObject {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
