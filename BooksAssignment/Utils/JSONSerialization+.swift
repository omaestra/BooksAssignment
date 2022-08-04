//
//  JSONSerialization+.swift
//  BooksAssignment
//
//  Created by omaestra on 4/4/22.
//

import Foundation

extension JSONSerialization {
    static func loadJSON(withFilename filename: String) throws -> Any? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
            return jsonObject
        }
        return nil
    }
    
    static func save(jsonObject: Any, toFilename filename: String) throws -> Bool {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            if JSONSerialization.isValidJSONObject(jsonObject) {
                let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.fragmentsAllowed])
                try data.write(to: fileURL, options: [.atomicWrite])
                return true
            }
        }
        
        return false
    }
}
