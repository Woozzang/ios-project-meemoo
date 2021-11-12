//
//  StoryboardInstantiable.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import Foundation
import UIKit

protocol StoryboardInstantiable {
  
  static var storyboardName: String { get }
  
  static func loadFromStoryBoard() -> UIViewController
}

extension StoryboardInstantiable {
  
  static func loadFromStoryBoard() -> UIViewController {
    
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    
    return storyboard.instantiateViewController(withIdentifier: String(describing: Self.self))
  }
  
}
