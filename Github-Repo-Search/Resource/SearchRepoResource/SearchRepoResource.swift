//
//  SearchRepoResource.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import Foundation

struct SearchRepoResource {
    func searchRepo(request: SearchRepoRequest,
                    completionHandler: @escaping (_ response: SearchRepoResponse?,
                                                  _ error: String?) -> Void) {
        do {
            
            let headers: [String: String] = [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer " + Constants.githubAccessToken,
                "X-GitHub-Api-Version": "2022-11-28"
            ]
            
            let huRequest = HURequest(withUrl: Constants.GithubSearchEndpoints.repository.url,
                                      forHttpMethod: .get,
                                      queryParams: try request.asDictionary(),
                                      headers: headers)
            
            HttpUtility.shared.request(huRequest: huRequest,
                                       resultType: SearchRepoResponse.self) { result in
                switch result {
                case .success(let success):
                    completionHandler(success, nil)
                case .failure(let failure):
                    completionHandler(nil, failure.reason)
                }
            }
        } catch let error {
            completionHandler(nil, error.localizedDescription)
        }
    }
}
