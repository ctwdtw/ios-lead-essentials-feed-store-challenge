//
//  RealmCache.swift
//  FeedStoreChallenge
//
//  Created by Paul Lee on 2020/10/2.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCache: Object {
    @objc dynamic private(set) var timestamp: Date = Date()
    let feed = List<RealmFeedImage>()
    
    convenience init(feed: [RealmFeedImage], timestamp: Date) {
        self.init()
        self.feed.append(objectsIn: feed)
        self.timestamp = timestamp
    }
    
}
