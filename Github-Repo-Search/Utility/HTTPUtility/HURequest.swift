//
//  HURequest.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import Foundation

protocol Request {
    var url: URL { get set }
    var method: HUHttpMethods { get set }
}

public struct HURequest: Request {
    var url: URL
    var method: HUHttpMethods
    var requestBody: Data?
    var queryParams: [String: String]
    var headers: [String: String]
    
    init(withUrl url: URL,
         forHttpMethod method: HUHttpMethods,
         requestBody: Data? = nil,
         queryParams: [String: String] = [:],
         headers: [String: String] = [:]) {
        self.url = url
        self.method = method
        self.requestBody = requestBody
        self.queryParams = queryParams
        self.headers = headers
    }
}
