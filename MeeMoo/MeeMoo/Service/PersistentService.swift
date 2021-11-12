//
//  PersistentService.swift
//  MeeMoo
//
//  Created by Woochan Park on 2021/11/12.
//

import Foundation
import RealmSwift

class PersistentService {
  
  static var standard = PersistentService()
  
  private var userDefaults = UserDefaults.standard
  
  private let isFirstLaunchKey: String = "isFirstLaunch"
  
  private var localDB = try! Realm()
  
  var locablDBPath: String? {
    localDB.configuration.fileURL?.path
  }
  
  private init() { }
  
  /*
   앱 최초 실행인지 확인하는 계산속성
   */
  
  var isFirstLaunch: Bool {
    
    let result = userDefaults.bool(forKey: isFirstLaunchKey)
    
    if result {
      return result
    }
    
    userDefaults.set(true, forKey: isFirstLaunchKey)
    
    return false
  }
  
  func write(_ memo: Memo) {
    
    try! localDB.write {
      localDB.add(memo)
    }
  }
  
  func read(isPinned: Bool = false) -> [Memo] {
    
    return localDB.objects(Memo.self).where {
      $0.isPinned == isPinned
    }.sorted { lhs, rhs in
      return lhs.createdDate > rhs.createdDate
    }
  }
  
  func update(with memo: Memo) {
    
    guard let previousMemo = localDB.object(ofType: Memo.self, forPrimaryKey: memo.id) else { return }
    
    try! localDB.write {
      
      previousMemo.title = memo.title
      previousMemo.payload = memo.payload
      previousMemo.isPinned = memo.isPinned
    }
  }
  
  /*
   전달된 memo 를 삭제하고, 반영된 db 를 반환한다.
   */
  func delete(_ memo: Memo) -> [Memo] {
    
    try! localDB.write {
      localDB.delete(memo)
    }
    
    return localDB.objects(Memo.self).sorted { lhs, rhs in
      return lhs.createdDate > rhs.createdDate
    }
  }
  
}
