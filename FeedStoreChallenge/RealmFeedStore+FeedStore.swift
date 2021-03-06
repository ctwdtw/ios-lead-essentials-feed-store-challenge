//
//  RealmFeedStore+FeedStore.swift
//  FeedStoreChallenge
//
//  Created by Paul Lee on 2020/10/2.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

//MARK: - RealmFeedStore+FeedStore
extension RealmFeedStore: FeedStore {
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        executeWithBarrier { realmFactory in
            do {
                let realm = try realmFactory()
                try realm.write {
                    realm.deleteAll()
                }
                completion(nil)
                
            } catch {
                completion(error)
                
            }
            
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        executeWithBarrier { realmFactory in
            let realmFeed = feed.toRealmModels()
            let cache = RealmCache(feed: realmFeed, timestamp: timestamp)
            
            do {
                let realm = try realmFactory()
                try realm.write {
                    realm.deleteAll()
                    realm.add(cache)
                }
                completion(nil)
                
            } catch {
                completion(error)
                
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        execute { realmFactory in
            do {
                let realm = try realmFactory()
                
                guard let cache = realm.objects(RealmCache.self).first else {
                    completion(.empty); return
                }
                
                let localFeed = Array(cache.feed).toLocals()
                completion(.found(feed: localFeed, timestamp: cache.timestamp))
                
            } catch {
                completion(.failure(error))
                
            }
        }
    }
}

//MARK: - helpers
private extension Array where Element == RealmFeedImage {
    func toLocals() -> [LocalFeedImage] {
        return compactMap {
            guard let uuid = UUID(uuidString: $0.id) else { return nil }
            
            guard let url = URL(string: $0.url) else { return nil }
            
            return LocalFeedImage(id: uuid,
                                  description: $0.imageDescription,
                                  location: $0.location,
                                  url: url)
        }
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
