//
//  Realm.swift
//  FeedStoreChallenge
//
//  Created by Paul Lee on 2020/10/2.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Realm {
  func add(_ object: Object, update: RealmSwift.Realm.UpdatePolicy)
  
  func objects<Element>(_ type: Element.Type) -> Results<Element> where Element : Object
  
  func deleteAll()
  
  @discardableResult
  func write<Result>(withoutNotifying tokens: [NotificationToken], _ block: (() throws -> Result)) throws -> Result
}

extension Realm {
  func write<Result>(_ block: (() throws -> Result)) throws -> Result {
    try write(withoutNotifying: [], block)
  }
  
  func add(_ object: Object) {
    add(object, update: .error)
  }
}

extension RealmSwift.Realm: Realm {}
