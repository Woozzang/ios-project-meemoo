//
//  SearchResultsTableViewController.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import UIKit

final class SearchResultsTableViewController: UITableViewController {
  
  let persistentService = PersistentService.standard
  
  var searchResults: [Memo] = [] {
    
    didSet {
      
      sectionHeaderTitle = searchResults.isEmpty ? "검색 결과 없음" : "\(searchResults.count)개 찾음"
      
      if let tableView = tableView {
        tableView.reloadData()
      }
    }
  }
  
  var targetKeyword: String?
  
  var sectionHeaderTitle: String?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setUpTableView()
    
    registerCells()
  }
  
  private func registerCells() {
    
    let cellNib = UINib(nibName: MemoTableViewCell.nibName, bundle: nil)
    
    tableView.register(cellNib, forCellReuseIdentifier: MemoTableViewCell.identifier)
  }
  
  private func setUpTableView() {
    tableView.backgroundColor = .white
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
    cell.titleLabel.makeTargetGreen(targetString: targetKeyword ?? "")
    
    cell.payloadLabel.text = searchResults[indexPath.row].payload
    cell.payloadLabel.makeTargetGreen(targetString: targetKeyword ?? "")
    
    cell.createdDate = searchResults[indexPath.row].createdDate
    
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let vc = EditMemoViewController.loadFromStoryBoard() as? EditMemoViewController else { return }
    
    guard let indexPath = tableView.indexPathForSelectedRow else { return }

    var memo: Memo

    if indexPath.section == 0 {
      memo = searchResults[indexPath.row]

    } else {
      memo = searchResults[indexPath.row]
    }

    vc.memo = memo
    
    self.presentingViewController?.navigationItem.backButtonTitle = "검색"
    
    self.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
  }
  
  /*
   스와이프 액션
   */
  
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let target = searchResults[indexPath.row]
    
    let pinAction = UIContextualAction(style: .normal, title: nil) { [self] _, _, closure in

      try! persistentService.localDB.write {
        target.isPinned.toggle()
      }
      
      closure(true)
    }
    
    pinAction.image = target.isPinned ?  UIImage(systemName: "pin.fill") : UIImage(systemName: "pin")

    pinAction.backgroundColor = .orange
    
    return UISwipeActionsConfiguration(actions: [pinAction])
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .normal, title: nil) { [self] _, _, closure in
        
      let target = searchResults[indexPath.row]
      
      let alertController = UIAlertController(title: "정말 삭제하시나요?", message: "한번 삭제되면 다시 불러올 수 없어요", preferredStyle: .alert)
      
      let deleteAction = UIAlertAction(title: "삭제할게요", style: .destructive, handler: { _ in
        
        persistentService.delete(target)
        
        searchResults = persistentService.search(by: targetKeyword ?? "")
        
        closure(true)
      })
      
      let cancelAction = UIAlertAction(title: "취소할게요", style: .default, handler: { _ in
        
        closure(false)
      })
      
      alertController.addAction(deleteAction)
      alertController.addAction(cancelAction)
      
      present(alertController, animated: true, completion: nil)
    }

    deleteAction.image = UIImage(systemName: "xmark")
    
    deleteAction.backgroundColor = .systemRed
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
    
  }
}

extension SearchResultsTableViewController: StoryboardInstantiable {
  
  static var storyboardName: String {
    return "SearchResults"
  }
}
