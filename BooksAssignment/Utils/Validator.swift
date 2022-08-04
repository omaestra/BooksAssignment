//
//  Validator.swift
//  BooksAssignment
//
//  Created by omaestra on 4/4/22.
//
//  Acknowledgments to Khoa Pham https://dev.to/onmyway133/how-to-make-simple-form-validator-in-swift-1hlg

import Foundation
import UIKit

class Validator {
    func validate(text: String, with rules: [Rule]) -> String? {
        return rules.compactMap({ $0.check(text) }).first
    }

    func validate(input: UITextField, with rules: [Rule]) -> Bool {
        guard let message = validate(text: input.text ?? "", with: rules) else {
            input.placeholder = nil
            input.layer.borderColor = nil
            input.layer.borderWidth = 0
            return true
        }

        input.placeholder = message
        input.layer.borderWidth = 1
        input.layer.borderColor = UIColor.red.cgColor
        return false
    }
}

struct Rule {
    // Return nil if matches, error message otherwise
    let check: (String) -> String?

    static let notEmpty = Rule(check: {
        return $0.isEmpty ? "Must not be empty" : nil
    })

    static let validNumber = Rule(check: {
        let regex = "^[0-9]+$"

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: $0) ? nil : "Must have valid number"
    })
}
