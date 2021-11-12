//
//  SearchResultsTableViewController.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
  

  
  var searchResults: [Memo] = [] {
    didSet {
      
      sectionHeaderTitle = "\(searchResults.count)개 찾음"
    }
  }
  
  var targetKeyword: String?
  
  var sectionHeaderTitle: String?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    registerCells()
  }
  
  private func registerCells() {
    
    let cellNib = UINib(nibName: MemoTableViewCell.nibName, bundle: nil)
    
    tableView.register(cellNib, forCellReuseIdentifier: MemoTableViewCell.identifier)
  }
  
  private func setUpTableView() {
    
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return searchResults.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier, for: indexPath) as? MemoTableViewCell else { return UITableViewCell()}
    
    cell.titleLabel.text = searchResults[indexPath.row].title
    cell.titleLabel.makeTargetYellow(targetString: targetKeyword ?? "")
    
    
    cell.payloadLabel.text = searchResults[indexPath.row].payload
    cell.payloadLabel.makeTargetYellow(targetString: targetKeyword ?? "")
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    guard let sectionHeaderView = MemoSectionHeaderView.loadFromXib() as? MemoSectionHeaderView else { return nil }
    
    sectionHeaderView.sectionTitleLabel.text = sectionHeaderTitle
    
    return sectionHeaderView
    
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 80
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
}

extension SearchResultsTableViewController: StoryboardInstantiable {
  
  static var storyboardName: String {
    return "SearchResults"
  }
}
