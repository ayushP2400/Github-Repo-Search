//
//  SearchGithubRepositoryViewController.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import UIKit
import Combine

class SearchGithubRepositoryViewController: UIViewController {

    @IBOutlet weak var repoResultsTableView: UITableView!
    
    let searchGithubViewModel = SearchGithubViewModel()
    
    @Published var searchQuery: String = ""
    
    var searchResultStream: AnyCancellable?
    var searchItems: [repoItems] = []
    
    var searchResult: AnyPublisher<[repoItems], Never> {
        return $searchQuery
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { searchQuery in
                return Future { promise in
                    self.searchGithubViewModel.searchRepo(with: searchQuery) { result, error in
                        promise(.success(result))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultStream = self.searchResult
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] items in
                self.searchItems = items
                self.repoResultsTableView.reloadData()
            })
        
        repoResultsTableView.keyboardDismissMode = .interactive
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        searchQuery = sender.text ?? ""
    }
    @IBAction func searchKeyboardDismiss(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

extension SearchGithubRepositoryViewController: UITableViewDelegate,
                                                UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = searchItems[indexPath.row].name
        return cell
    }
}
