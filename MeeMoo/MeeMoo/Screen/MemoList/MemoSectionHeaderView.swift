//
//  MemoSectionHeaderView.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import UIKit

class MemoSectionHeaderView: UIView {
  
  @IBOutlet weak var sectionTitleLabel: UILabel! {
    didSet {
      sectionTitleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    }
  }
}

extension MemoSectionHeaderView: NibInstantiable {
  
  static var nibName: String  {
    return "MemoSectionHeader"
  }
}
