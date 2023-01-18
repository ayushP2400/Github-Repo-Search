//
//  Constants.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import Foundation

class Constants {
    static let githubAccessToken = "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"
    static let githubBaseURL = "https://api.github.com"
    
    enum GithubSearchEndpoints: String {
        case repository = "/search/repositories"
        var url: URL {
            return URL(string: Constants.githubBaseURL + self.rawValue)!
        }
    }
}

