//
//  Constants.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import Foundation

class Constants {
    static let githubAccessToken = "" // YOUR GITHUB TOKEN
    static let githubBaseURL = "https://api.github.com"
    
    enum GithubSearchEndpoints: String {
        case repository = "/search/repositories"
        var url: URL {
            return URL(string: Constants.githubBaseURL + self.rawValue)!
        }
    }
}

