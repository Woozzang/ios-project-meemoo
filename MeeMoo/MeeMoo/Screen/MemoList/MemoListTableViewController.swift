//
//  MemoListTableViewController.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/10.
//

import UIKit
import RealmSwift

final class MemoListTableViewController: UITableViewController, UISearchControllerDelegate {
  
  let numberFormatter: NumberFormatter = {
    
    $0.locale = Locale.current
    $0.numberStyle = NumberFormatter.Style.decimal
    $0.usesGroupingSeparator = true
    
    return $0
  }(NumberFormatter())
  
  private var persistentService = PersistentService.standard
  
  private var pinnedMemos: [Memo] = [] {
    didSet {
      tableView.reloadData()
      
      numberOfMemos = unpinnedMemos.count + pinnedMemos.count
    }
  }
  
  private var unpinnedMemos: [Memo] = [] {
    didSet {
      tableView.reloadData()
      
      numberOfMemos = unpinnedMemos.count + pinnedMemos.count
    }
  }
  
  var token: NotificationToken?
  
  private var numberOfMemos: Int = 0 {
    didSet {
      
      guard let numberText = numberFormatter.string(from: numberOfMemos as NSNumber) else { return }
      
      title = numberText + "개의 메모"
    }
  }
  
  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateMemos()
  
    registerCells()
    
    setUpNavigationItem()
    
    setUpSearchController()
    
    observeMemoModels()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
   updateMemos()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if persistentService.isFirstLaunch {
      let alertController = UIAlertController(title: "처음이시군요!", message: "환영해요", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "넹", style: .default, handler: nil)
      
      alertController.addAction(okAction)
      
      present(alertController, animated: true, completion: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    navigationItem.backButtonTitle = "메모"
    
    guard let isCreatingMemo = sender as? Bool else { return }
    
    guard let vc = segue.destination as? EditMemoViewController else  { return }
    
    /*
     메모 생성 버튼을 클릭한 경우
     */
    if isCreatingMemo {

      
      vc.isMemoEditing = true
      
      vc.persistentService = PersistentService.standard
      
      return
    }
    
    /*
    셀을 선택한 경우
     */
    
    guard let indexPath = tableView.indexPathForSelectedRow else { return }
    
    var memo: Memo
    
    if indexPath.section == 0 {
      memo = pinnedMemos[indexPath.row]
      
    } else {
      memo = unpinnedMemos[indexPath.row]
    }
    
    vc.memo = memo
  }
  
  deinit {
    token = nil
  }
  
  private func setUpNavigationItem() {
    
    navigationItem.largeTitleDisplayMode = .always
    
    /*
     시작시 largeTitle 이 바로 보이지 않고 끌어 댕겨야 그 이후부터 보이기 시작해서 사용
     */
    tableView.contentOffset = CGPoint(x: 0, y: -100)
  }
  
  func updateMemos() {
    
    pinnedMemos = persistentService.read(isPinned: true)
    
    unpinnedMemos = persistentService.read()
    
  }
  
  func observeMemoModels() {
    
    token = persistentService.localDB.objects(Memo.self).observe(on: .main) { [weak self] change in
      
      guard let self = self else { return }
      
      switch change {
        case .update(_, _, _, _):
          
          self.pinnedMemos = self.persistentService.read(isPinned: true)
          self.unpinnedMemos = self.persistentService.read()
          
        default :
          break
      }
    }
  }
  
  private func registerCells() {
    
    let nib = UINib(nibName: "MemoCell", bundle: nil)
    
    tableView.register(nib, forCellReuseIdentifier: MemoTableViewCell.identifier)
  }
  
  private func setUpSearchController() {
    
    let searchResultsController = SearchResultsTableViewController.loadFromStoryBoard()
    
    let searchController = UISearchController(searchResultsController: searchResultsController)
    
    searchController.searchResultsUpdater = self
    
    searchController.searchBar.placeholder = "검색"
    
    navigationItem.searchController = searchController
    
    navigationItem.hidesSearchBarWhenScrolling = false
    
  }
  
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
        return pinnedMemos.count
        
      /*
       그냥 메모
       */
      case 1:
        return unpinnedMemos.count
        
      default:
        return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier, for: indexPath) as? MemoTableViewCell else { return UITableViewCell() }
    
    let data = indexPath.section == 0 ? pinnedMemos[indexPath.row] : unpinnedMemos[indexPath.row]
    
    cell.titleLabel.text = data.title
    cell.payloadLabel.text = data.payload
    
    cell.createdDate = data.createdDate
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    guard let sectionHeaderView = MemoSectionHeaderView.loadFromXib() as? MemoSectionHeaderView else { return nil }
    
    var title: String = ""

    switch section {
      /*
       고정된 메모
       */
      case 0:
        guard !pinnedMemos.isEmpty else { return nil }

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
    
    return sectionHeaderView
    
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    if section == 0, pinnedMemos.isEmpty {
      return 0
    }
    
    return 60
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let pinAction = UIContextualAction(style: .normal, title: nil) { [self] _, _, closure in
      
      if indexPath.section == 0 {
        
        guard indexPath.row < pinnedMemos.count else { closure(false); return }
        
        let target = pinnedMemos[indexPath.row]
        
        try! persistentService.localDB.write {
          target.isPinned.toggle()
        }
        
        closure(true)
        
        
      } else {
        
        guard pinnedMemos.count < 5 else {
          
          let alertController = UIAlertController(title: "고정 메모 개수 제한", message: "최대 5개 까지만 고정할 수 있어요", preferredStyle: .alert)
          
          let okAction = UIAlertAction(title: "알겠어요", style: .default, handler: { _ in
            closure(false)
          })
          
          alertController.addAction(okAction)
          
          present(alertController, animated: true, completion: nil)
          
          return
        }
        
        guard indexPath.row < unpinnedMemos.count else { closure(false); return }
        
        let target = unpinnedMemos[indexPath.row]
          
        
        try! persistentService.localDB.write {
          target.isPinned.toggle()
        }
        
        closure(true)
      }
    }
    
    if indexPath.section == 0 {
      pinAction.image = UIImage(systemName: "pin.fill")
    } else {
      pinAction.image = UIImage(systemName: "pin")
    }
    
    pinAction.backgroundColor = .orange
    
    return UISwipeActionsConfiguration(actions: [pinAction])
  }
  
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .normal, title: nil) { [self] _, _, closure in
      
      if indexPath.section == 0 {
        
        guard indexPath.row < pinnedMemos.count else { closure(false); return }
        
        let target = pinnedMemos[indexPath.row]
        
        let alertController = UIAlertController(title: "정말 삭제하시나요?", message: "한번 삭제되면 다시 불러올 수 없어요", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "삭제할게요", style: .destructive, handler: { _ in
          persistentService.delete(target)
          
          closure(true)
        })
        
        let cancelAction = UIAlertAction(title: "취소할게요", style: .default, handler: { _ in
          
          closure(false)
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)

      } else {
        
        guard indexPath.row < unpinnedMemos.count else { closure(false); return }
        
        let target = unpinnedMemos[indexPath.row]
        
        let alertController = UIAlertController(title: "정말 삭제하시나요?", message: "한번 삭제되면 다시 불러올 수 없어요", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "삭제할게요", style: .destructive, handler: { _ in
          persistentService.delete(target)
          
          closure(true)
        })
        
        let cancelAction = UIAlertAction(title: "취소할게요", style: .default, handler: { _ in
          
          closure(false)
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
      }
    }

    deleteAction.image = UIImage(systemName: "xmark")
    
    deleteAction.backgroundColor = .systemRed
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: EditMemoViewController.segueIdentifier, sender: false)
    
  }
  
  
  @IBAction func didTapCreateNoteButton(_ sender: UIBarButtonItem) {
    
    performSegue(withIdentifier: EditMemoViewController.segueIdentifier, sender: true)
  }
}

extension MemoListTableViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
    guard let searchResultsController = searchController.searchResultsController as? SearchResultsTableViewController else { return }
    
    guard let targetKeyword = searchController.searchBar.text else { return }
    
    searchResultsController.updateSearchResults(with: targetKeyword)
    
    return
  }
}
