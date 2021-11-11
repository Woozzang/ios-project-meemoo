//
//  CreateMemoViewController.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/10.
//

import UIKit

class CreateMemoViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!
  
  var isMemoEditing = false {
    didSet {
      navigationItem.rightBarButtonItems = isMemoEditing ? barItemsOnEditing : nil
    }
  }
  
  let barItemsOnEditing = [
    UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishEditing)),
    UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareMemo))
  ]
  
  
  override func viewDidLoad() {
      super.viewDidLoad()
      
    navigationController?.toolbar.isHidden = true
    
    if textView.canBecomeFirstResponder {
      textView.becomeFirstResponder()
    }
    
    navigationItem.largeTitleDisplayMode = .never
    
  }
  
  /*
   툴바를 다시 보여준다
   */
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.toolbar.isHidden = false
  }
  
  @objc func shareMemo() {
    print(#function)
  }
  
  @objc func finishEditing() {
    print(#function)
  }
  
}

// MARK: - UITextViewDelegate

extension CreateMemoViewController: UITextViewDelegate {
  
  /*
   키보드는 내려가지 않습니다.
   */
  
  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    return false
  }
}
