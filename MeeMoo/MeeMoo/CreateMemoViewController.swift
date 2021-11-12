//
//  CreateMemoViewController.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/10.
//

import UIKit

final class CreateMemoViewController: UIViewController {

  @IBOutlet private weak var textView: UITextView!
  
  var persistentServie: PersistentService?
  
  var isMemoEditing = false {
    didSet {
      navigationItem.rightBarButtonItems = isMemoEditing ? barItemsOnEditing : nil
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
    
    if textView.canBecomeFirstResponder {
      textView.becomeFirstResponder()
    }
    
    navigationItem.largeTitleDisplayMode = .never
    
  }
  
  private func setUpTextView() {
    
    textView.delegate = self
  }
  
  /*
   툴바를 다시 보여준다
   */
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.toolbar.isHidden = false
  }
  
  @objc func shareMemo() {
    
  }
  
  @objc func finishEditing() {
    
    defer {
      isMemoEditing = false
    }
    
    guard let text = textView.text, !text.isEmpty else { return }
    
    let lines = text.split(separator: "\n").map { String($0) }
    
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
    persistentServie?.write(newMemo)
  }
  
}

// MARK: - UITextViewDelegate

extension CreateMemoViewController: UITextViewDelegate {
  
}
