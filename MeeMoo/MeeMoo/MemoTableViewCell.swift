//
//  MemoTableViewCell.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
  
  static var identifier = String(describing: MemoTableViewCell.self)
  
  var isPinned: Bool = false

  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var cellLabel: UILabel!
  
  @IBOutlet weak var payloadLabel: UILabel!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }
}
