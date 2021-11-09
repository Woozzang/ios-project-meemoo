//
//  MemoListTableViewController.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/10.
//

import UIKit

class MemoListTableViewController: UITableViewController {
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
      
      let search = UISearchController(searchResultsController: nil)
      
      search.searchResultsUpdater = self
      
      search.obscuresBackgroundDuringPresentation = false
      
      search.searchBar.placeholder = "검색"
      
      navigationItem.searchController = search
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

extension MemoListTableViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
    print(#function)
  }
}
