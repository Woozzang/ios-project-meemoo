//
//  NibInstantiable.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import Foundation
import UIKit

protocol NibInstantiable {
  static func loadFromXib() -> UIView
}

extension NibInstantiable {
  
  static func loadFromXib() -> UIView {
      return UINib(nibName: "MemoSectionHeader", bundle: nil).instantiate(withOwner: nil, options: nil).first! as! UIView
  }
}

