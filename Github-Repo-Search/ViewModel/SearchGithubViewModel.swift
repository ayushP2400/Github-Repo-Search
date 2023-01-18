//
//  SearchGithubViewModel.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import Foundation

protocol SearchGithubDelegate {
    func searchRepo(with keyword: String,
                    completion: @escaping (_ result: [repoItems],
                                           _ error: String?) -> Void)
}

class SearchGithubViewModel: SearchGithubDelegate {
    
    func searchRepo(with keyword: String,
                    completion: @escaping (_ result: [repoItems],
                                           _ error: String?) -> Void) {
        let resource = SearchRepoResource()
        let request = SearchRepoRequest(searchQuery: keyword)
        resource.searchRepo(request: request,
                            completionHandler: { response, error in
            if let response = response {
                if let items = response.items {
                    completion(items, nil)
                } else {
                    completion([], response.message)
                }
            } else {
                completion([], error)
            }
        })
    }
}
