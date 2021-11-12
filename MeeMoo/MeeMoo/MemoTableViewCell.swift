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
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var payloadLabel: UILabel!
  
  var createdDate: Date? {
    didSet {
      
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
    dateLabel.textColor = .systemGray
    
    payloadLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
    payloadLabel.textColor = .systemGray
  }
}
