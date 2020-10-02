//
//  RealmFeedImage.swift
//  FeedStoreChallenge
//
//  Created by Paul Lee on 2020/10/2.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

class RealmFeedImage: Object {
    @objc dynamic private(set) var id: String = ""
    @objc dynamic private(set) var imageDescription: String? = nil
    @objc dynamic private(set) var location: String? = nil
    @objc dynamic private(set) var url: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, imageDescription: String?, location: String?, url: String) {
        self.init()
        self.id = id
        self.imageDescription = imageDescription
        self.location = location
        self.url = url
    }
    
}
