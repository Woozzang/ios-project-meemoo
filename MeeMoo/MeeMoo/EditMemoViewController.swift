//
//  CreateMemoViewController.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/10.
//

import UIKit

final class EditMemoViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!
  
  static var segueIdentifier = "EditMemoSegue"
  
  var memo: Memo?
  
  var persistentService: PersistentService = PersistentService.standard
  
  var isMemoEditing = false {
    didSet {
      navigationItem.rightBarButtonItems = isMemoEditing ? barItemsOnEditing : nil
      
      guard let textView = textView else { return }
      
      if isMemoEditing {
        textView.becomeFirstResponder()
      } else {
        textView.resignFirstResponder()
      }
    }
  }
  
  let barItemsOnEditing = [
    UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishEditing)),
    UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareMemo))
  ]
  
//  var indexOfFirstLineBreak: Index?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTextView()
    
    navigationController?.toolbar.isHidden = true
    
    navigationItem.largeTitleDisplayMode = .never
    
  }

  
  /*
   툴바를 다시 보여준다
   */
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.toolbar.isHidden = false
  }
  

  
  private func setUpTextView() {
    
    textView.delegate = self
    
    if isMemoEditing {
      textView.becomeFirstResponder()
    } else {
      textView.resignFirstResponder()
    }
    
    guard let memo = memo else { return }
    
    textView.text = memo.title + "\n" + (memo.payload ?? "")
  }
  
  // MARK: - Objc Methodd
  
  @objc func shareMemo() {
    
  }
  
  
  @objc func finishEditing() {
    
    defer {
      isMemoEditing = false
    }
    
    guard let text = textView.text, !text.isEmpty else { return }
    
    let lines = text.split(separator: "\n").map { String($0) }
    
    /*
     셀을 통해 들어왔다면
     */
    if let memo = memo {
      
      try! persistentService.localDB.write({
        memo.title = lines.first!
        memo.payload = lines[1...].joined(separator: "\n")
      })
      
      return
    }
    
    let newMemo = Memo()
    newMemo.title = lines.first!
    newMemo.createdDate = Date()
    newMemo.isPinned = false
    
    if lines.count > 1 {
      
      let payload = lines[1...].joined(separator: "\n")
      newMemo.payload = payload
    }
    
    /*
     DB에 넣기
     */
    persistentService.write(newMemo)
  }
  
}

// MARK: - UITextViewDelegate

extension EditMemoViewController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    navigationItem.rightBarButtonItems = barItemsOnEditing
  }
}
