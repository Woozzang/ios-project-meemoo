//
//  UITextView+Extensions.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import Foundation
import UIKit

extension UILabel {
  
    func makeKeywordGreen(_ keyword: String) {
      
      let fullText = self.text ?? ""
      
      let range = (fullText as NSString).range(of: keyword)
      
      let textColor = UIColor.systemGreen
      
      let attributedString = NSMutableAttributedString(string: fullText)
      
      attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
      
      self.attributedText = attributedString
    }
}
