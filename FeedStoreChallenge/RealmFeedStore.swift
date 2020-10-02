//
//  RealmFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Paul Lee on 2020/10/2.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmFeedStore: FeedStore {
  private let realmQueue = DispatchQueue(label: "feedStore.realm.queue", attributes: .concurrent)
  
  private let realmFactory: RealmFactory
  
  public typealias RealmFactory = () throws -> Realm
  
  public init(factory: @escaping RealmFactory) {
    self.realmFactory = factory
  }
  
  public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
    realmQueue.async(flags: .barrier) {
      let realm = try! self.realmFactory()
      
      try! realm.write {
        realm.deleteAll()
      }
      
      completion(nil)
    }
  }
  
  public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    realmQueue.async(flags: .barrier) {
      let realmFeed = feed.toRealmModels()
      let cache = RealmCache(feed: realmFeed, timestamp: timestamp)
      let realm = try! self.realmFactory()
      try! realm.write {
        realm.deleteAll()
        realm.add(cache)
      }
  
      completion(nil)
    }
  }
  
  public func retrieve(completion: @escaping RetrievalCompletion) {
    realmQueue.async {
      let realm = try! self.realmFactory()
      guard let cache = realm.objects(RealmCache.self).first else { completion(.empty); return }
      let localFeed = Array(cache.feed).toLocals()
      
      completion(.found(feed: localFeed, timestamp: cache.timestamp))
    }
  }
  
}

private extension Array where Element == RealmFeedImage {
  func toLocals() -> [LocalFeedImage] {
    let localFeed = map { LocalFeedImage(id: UUID(uuidString: $0.id)!,
                                         description: $0.imageDescription,
                                         location: $0.location,
                                         url: URL(string: $0.url)!) }
    return localFeed
  }
}

private extension Array where Element == LocalFeedImage {
  func toRealmModels() -> [RealmFeedImage] {
    let feed = map { RealmFeedImage(id: $0.id.uuidString,
                                    imageDescription: $0.description,
                                    location: $0.location,
                                    url: $0.url.absoluteString) }
    return feed
  }
}

