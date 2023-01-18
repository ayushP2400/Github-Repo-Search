//
//  EncodableExtension.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: String] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                options: .allowFragments) as? [String: String] else {
            throw NSError()
        }
        return dictionary
    }
}
