//
//  SearchRepoResponse.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import Foundation

// MARK: - SearchRepoResponse
struct SearchRepoResponse: Decodable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [repoItems]?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items, message
    }
}

// MARK: - repoItems
struct repoItems: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
