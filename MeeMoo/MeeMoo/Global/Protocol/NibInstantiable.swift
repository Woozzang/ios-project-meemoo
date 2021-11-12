//
//  NibInstantiable.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import Foundation
import UIKit

protocol NibInstantiable {
  
  static var nibName: String { get }
  
  static func loadFromXib() -> UIView
  
  static func loadNib() -> UINib
}

extension NibInstantiable {
  
  static func loadFromXib() -> UIView {
    
    return UINib(nibName: self.nibName, bundle: nil).instantiate(withOwner: nil, options: nil).first! as! UIView
  }
  
  static func loadNib() -> UINib {
    
    let nib = UINib(nibName: self.nibName, bundle: nil)
    
    return nib
  }
}

