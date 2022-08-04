//
//  UIView+.swift
//  BooksAssignment
//
//  Created by omaestra on 4/4/22.
//

import Foundation
import UIKit

extension UIView {
    func fixedLayout(in container: UIView) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        
        self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        let bottomConstraint = self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        bottomConstraint.isActive = true
    }
}
