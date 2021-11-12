//
//  Memo.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import Foundation
import RealmSwift

class Memo: Object {
  
  @Persisted(primaryKey: true) var id: ObjectId
  
  @Persisted var title: String
  
  @Persisted var payload: String?
  
  @Persisted var createdDate: Date
  
  @Persisted var isPinned: Bool
}
