//
//  MemoSectionHeaderView.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import UIKit

class MemoSectionHeaderView: UIView, NibInstantiable {
  
  @IBOutlet weak var sectionTitleLabel: UILabel! {
    didSet {
      sectionTitleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    }
  }
}
