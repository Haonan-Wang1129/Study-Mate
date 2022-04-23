//
//  SearchViewController.swift
//  studymate
//
//  Created by Haonan Wang on 4/22/22.
//

import UIKit
import CryptoKit
import Alamofire

class SearchViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    var colleges = [CollegeInfo]()
    var callBack: ((_ collegeName: String) -> Void)?
    var searchController: UISearchController!
    let collegeApiUrl = "https://api.collegeai.com/v1/api/autocomplete/colleges?api_key=b47484dd6e228ea2cc5e1bf6ca&query="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollegeCell.self, forCellReuseIdentifier: "CollegeCell")
        getColleges(contentInSearch: "")
        configureSearchController()
    }
    
    func getColleges(contentInSearch: String) {
        guard let url = URL(string: (collegeApiUrl + contentInSearch)) else { return }
        URLSession.shared.fetchData(for: url) {(result: Result<Initial, Error>) in
            switch result {
            case .success(let initial):
                self.colleges = initial.collegeList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("failed fetching college list from API: \(error)")
            }
        }
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()

        self.tableView.tableHeaderView = searchController.searchBar
    }
}


// contains function to fetch data from API url
extension URLSession {
  func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
    self.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
      }
      if let data = data {
        do {
          let object = try JSONDecoder().decode(T.self, from: data)
            completion(.success(object))
        } catch let decoderError {
          completion(.failure(decoderError))
        }
      }
    }.resume()
  }
}

// deal with table view stuffs
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollegeCell", for: indexPath) as! CollegeCell
        let college = colleges[indexPath.row]

        cell.univName.text = college.name
        cell.univLocation.text = college.city + ", " + college.state
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(colleges.count)
        return colleges.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CollegeCell
        callBack?(cell.univName.text ?? "selection failed")
        searchController.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}

// deal with search bar stuffs
extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        let words = searchString.components(separatedBy: " ")
        
        if words.isEmpty {
            getColleges(contentInSearch: searchString)
        } else {
            let apiCode = words.joined(separator: "%20")
            getColleges(contentInSearch: apiCode)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}
