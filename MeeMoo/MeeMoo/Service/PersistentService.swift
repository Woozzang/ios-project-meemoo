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
  
  func delete(_ memo: Memo) {
    
  }
  
}
