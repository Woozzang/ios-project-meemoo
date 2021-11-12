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
  
  private let didLaunchBeforeKey: String = "didLaunchBefore"
  
  var token: NotificationToken?
  
  var localDB = try! Realm()
  
  var locablDBPath: String? {
    localDB.configuration.fileURL?.path
  }
  
  var pinnedMemoList: [Memo] = []
  
  var notPinnedMemoList: [Memo] = []
  
  private init() {
    observeMemoModels()
  }
  
  /*
   앱 최초 실행인지 확인하는 계산속성
   */
  
  var didLaunchBefore: Bool {
    
    let result = userDefaults.bool(forKey: didLaunchBeforeKey)
    
    if result {
      
      return result
    }
    
    userDefaults.set(true, forKey: didLaunchBeforeKey)
    
    return false
  }
  
  var isFirstLaunch: Bool {
    return !didLaunchBefore
  }
  
  func observeMemoModels() {
    
    token = localDB.objects(Memo.self).observe(on: .main) { [weak self] change in
      
      guard let self = self else { return }
      
      switch change {
        case .update(_, _, _, _):
          
          self.pinnedMemoList = self.read(isPinned: true)
          self.notPinnedMemoList = self.read()
          
        default:
          break
      }
    }
    
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
  
  func search(by targetKeyword: String) -> [Memo] {
    
    let searchResults: [Memo] = localDB.objects(Memo.self).where {
      
      $0.title.contains(targetKeyword) || $0.payload.contains(targetKeyword)
    }.sorted { lhs, rhs in
      lhs.createdDate > rhs.createdDate
    }
    
    return searchResults
  }
  
}
