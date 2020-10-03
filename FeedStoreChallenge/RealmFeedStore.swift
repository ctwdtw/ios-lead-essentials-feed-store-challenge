//
//  RealmFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Paul Lee on 2020/10/2.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmFeedStore {
    private let realmQueue = DispatchQueue(label: "feedStore.realm.queue", attributes: .concurrent)
    
    private let realmFactory: RealmFactory
    
    public typealias RealmFactory = () throws -> Realm
    
    public init(factory: @escaping RealmFactory) {
        self.realmFactory = factory
    }
    
    func execute(_ op: @escaping (RealmFactory) -> Void) {
        realmQueue.async {
            op(self.realmFactory)
        }
    }
    
    func executeWithBarrier(_ op: @escaping (RealmFactory) -> Void) {
        realmQueue.async(flags: .barrier) {
            op(self.realmFactory)
        }
    }
    
}

