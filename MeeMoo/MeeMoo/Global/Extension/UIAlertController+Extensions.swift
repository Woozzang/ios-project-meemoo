//
//  UIAlertController+Extensions.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/13.
//

import Foundation
import UIKit

extension UIAlertController {
  
  static func createAlertController(title: String?, message: String?, with actions: [UIAlertAction]) -> UIAlertController {
    
    let alertController = self.init(title: title, message: message, preferredStyle: .alert)
    
    actions.forEach { action in
      alertController.addAction(action)
    }
    
    return alertController
  }
}
