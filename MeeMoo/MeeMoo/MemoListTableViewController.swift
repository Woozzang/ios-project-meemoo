//
//  MemoListTableViewController.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/10.
//

import UIKit

final class MemoListTableViewController: UITableViewController {
  
  private var numOfMemo: Int = 0 {
    didSet {
      title = "\(numOfMemo)개의 메모"
    }
  }
  
  private var persistentService = PersistentService.standard
  
  private var pinnedMemoList: [Memo] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  private var notPinnedmemoList: [Memo] = [] {
    didSet {
      tableView.reloadData()
      numOfMemo = notPinnedmemoList.count
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    pinnedMemoList = persistentService.read(isPinned: true)
    notPinnedmemoList = persistentService.read()
    
    registerCell()
    
    setUpSearchController()
    
//    setUpTableView()
    
    navigationItem.backButtonTitle = "메모"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    guard let isCreatingMemo = sender as? Bool else { return }
    
    if isCreatingMemo {
      guard let vc = segue.destination as? CreateMemoViewController else  { return }
      
      vc.isMemoEditing = true
      
      vc.persistentServie = PersistentService.standard
    }
  }
  
  private func registerCell() {
    
    let nib = UINib(nibName: "MemoCell", bundle: nil)
    
    tableView.register(nib, forCellReuseIdentifier: MemoTableViewCell.identifier)
  }
  
  private func setUpSearchController() {
    
    let search = UISearchController(searchResultsController: nil)
    
    search.searchResultsUpdater = self
    
    search.obscuresBackgroundDuringPresentation = false
    
    search.searchBar.placeholder = "검색"
    
    navigationItem.searchController = search
    
  }
  
//  private func setUpTableView() {
////    tableView.style = .insetGrouped
//
//    tableView.leadingAnchor.constraint(equalTo: )
//
//    NSLayoutConstraint.activate( [tableView.leadingAnchor.constraint(equalTo: safeAre),
//                                  tableView.topAnchor.constraint(equalTo: view.top)])
//  }
  
  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
    
    switch section {
      /*
       고정된 메모
       */
      case 0:
        return pinnedMemoList.count
        
      /*
       그냥 메모
       */
      case 1:
        return notPinnedmemoList.count
        
      default:
        return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier, for: indexPath) as? MemoTableViewCell else { return UITableViewCell() }
    
    return cell
  }
  
//  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//    switch section {
//      /*
//       고정된 메모
//       */
//      case 0:
//        return pinnedMemoList.count == 0 ? nil : "고정된 메모"
//
//      /*
//       그냥 메모
//       */
//      case 1:
//
//        let attributes: [NSAttributedString.Key : Any?] = [.font: UIFont.systemFont(ofSize:20, weight:.bold) ]
//
//        return NSAttributedString(string: "메모", attributes: attributes) as? String
//
//      default:
//        return ""
//    }
//  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    guard let sectionHeaderView = MemoSectionHeaderView.loadFromXib() as? MemoSectionHeaderView else { return nil }
    
    var title: String = ""

    switch section {
      /*
       고정된 메모
       */
      case 0:
        guard !pinnedMemoList.isEmpty else { return nil }

        title = "고정된 메모"
      /*
       그냥 메모
       */
      case 1:

        title = "메모"

      default:

        break
    }
    
    sectionHeaderView.sectionTitleLabel.text = title
    
    sectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
    sectionHeaderView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    
    return sectionHeaderView
    
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  @IBAction func didTapCreateNoteButton(_ sender: UIBarButtonItem) {
    
    performSegue(withIdentifier: "CreateMemoSegue", sender: true)
  }
}

extension MemoListTableViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
//    searchController.searchResultsController.tableView.reloadData()
  }
}
