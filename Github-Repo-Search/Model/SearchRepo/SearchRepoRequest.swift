//
//  SearchRepoRequest.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import Foundation

struct SearchRepoRequest: Encodable {
    let searchQuery: String
    
    enum CodingKeys: String, CodingKey {
        case searchQuery = "q"
    }
}
