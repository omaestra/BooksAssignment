//
//  Navigator.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation
import UIKit

protocol Navigator {
    associatedtype Destination
    
    func navigate(to destination: Destination, navigationType: NavigationType)
}

extension Navigator {
    func navigate(to destination: Destination, navigationType: NavigationType = .push) {
        navigate(to: destination, navigationType: navigationType)
    }
}

enum NavigationType {
    case push
    case overlay
}
