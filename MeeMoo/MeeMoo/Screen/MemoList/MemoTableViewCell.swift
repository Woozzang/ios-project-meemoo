//
//  MemoTableViewCell.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
  
  static var identifier = String(describing: MemoTableViewCell.self)
  
  private let dateFormatter: DateFormatter = {
    
    $0.locale = Locale(identifier: "kr_KR")
    
    return $0
  }(DateFormatter())
  
  var isPinned: Bool = false
  
  var createdDate: Date? {
    didSet {
      
      guard let createdDate = createdDate else {
        return
      }

      dateLabel.text = createDateString(with: createdDate)
    }
  }
  
  // MARK: - IBOutlet

  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var payloadLabel: UILabel!
  
  // MARK: - Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
    dateLabel.textColor = .systemGray
    
    payloadLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
    payloadLabel.textColor = .systemGray
  }
  
  // MARK: - Method
  
  private func createDateString(with createdDate: Date) -> String{
    
    /*
     오늘이면
     */

    if Calendar.current.isDateInToday(createdDate) {
      
      dateFormatter.dateFormat = "a hh시 mm분"
      
      return dateFormatter.string(from: createdDate)
    }
    
    /*
    이번 주이면
    */
    
    if Calendar.current.isDateInWeekend(createdDate) {
      
      dateFormatter.dateFormat = "EEEE HH시 mm분"
      
      return dateFormatter.string(from: createdDate)
    }
    
    /*
    그 외
     */
    
    dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
    
    return dateFormatter.string(from: createdDate)
  }
}

extension MemoTableViewCell: NibInstantiable {
  
  static var nibName: String  {
    return "MemoCell"
  }
}
