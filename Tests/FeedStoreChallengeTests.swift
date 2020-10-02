//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge
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

class RealmCache: Object {
  @objc dynamic private(set) var timestamp: Date = Date()
  let feed = List<RealmFeedImage>()
  
  convenience init(feed: [RealmFeedImage], timestamp: Date) {
    self.init()
    self.feed.append(objectsIn: feed)
    self.timestamp = timestamp
  }
  
}

public class RealmFeedStore: FeedStore {
  private let realm: Realm
  
  public init(realm: Realm) {
    self.realm = realm
  }
  
  public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
    
  }
  
  public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    let realmFeed = feed.map { RealmFeedImage(id: $0.id.uuidString, imageDescription: $0.description, location: $0.location, url: $0.url.absoluteString) }
    let cache = RealmCache(feed: realmFeed, timestamp: timestamp)
    
    try! realm.write { realm.add(cache) }
    
    completion(nil)
  }
  
  public func retrieve(completion: @escaping RetrievalCompletion) {
    guard let cache = realm.objects(RealmCache.self).first else { completion(.empty); return }
    let localFeed = cache.feed.map { LocalFeedImage(id: UUID(uuidString: $0.id)!, description: $0.imageDescription, location: $0.location, url: URL(string: $0.url)!) }
    
    completion(.found(feed: Array(localFeed), timestamp: cache.timestamp))
  }
  
}



class FeedStoreChallengeTests: XCTestCase, FeedStoreSpecs {
	
    //  ***********************
    //
    //  Follow the TDD process:
    //
    //  1. Uncomment and run one test at a time (run tests with CMD+U).
    //  2. Do the minimum to make the test pass and commit.
    //  3. Refactor if needed and commit again.
    //
    //  Repeat this process until all tests are passing.
    //
    //  ***********************

	func test_retrieve_deliversEmptyOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnNonEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_insert_overridesPreviouslyInsertedCacheValues() {
//		let sut = makeSUT()
//
//		assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
	}

	func test_delete_deliversNoErrorOnEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_delete_hasNoSideEffectsOnEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_delete_deliversNoErrorOnNonEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_delete_emptiesPreviouslyInsertedCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
	}

	func test_storeSideEffects_runSerially() {
//		let sut = makeSUT()
//
//		assertThatSideEffectsRunSerially(on: sut)
	}
	
	// - MARK: Helpers
	
  private func makeSUT() -> FeedStore {
    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "UnitTestInMemoryRealm"))
    let sut = RealmFeedStore(realm: realm)
    return sut
  }
	
}

//  ***********************
//
//  Uncomment the following tests if your implementation has failable operations.
//
//  Otherwise, delete the commented out code!
//
//  ***********************

//extension FeedStoreChallengeTests: FailableRetrieveFeedStoreSpecs {
//
//	func test_retrieve_deliversFailureOnRetrievalError() {
////		let sut = makeSUT()
////
////		assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
//	}
//
//	func test_retrieve_hasNoSideEffectsOnFailure() {
////		let sut = makeSUT()
////
////		assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
//	}
//
//}

//extension FeedStoreChallengeTests: FailableInsertFeedStoreSpecs {
//
//	func test_insert_deliversErrorOnInsertionError() {
////		let sut = makeSUT()
////
////		assertThatInsertDeliversErrorOnInsertionError(on: sut)
//	}
//
//	func test_insert_hasNoSideEffectsOnInsertionError() {
////		let sut = makeSUT()
////
////		assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
//	}
//
//}

//extension FeedStoreChallengeTests: FailableDeleteFeedStoreSpecs {
//
//	func test_delete_deliversErrorOnDeletionError() {
////		let sut = makeSUT()
////
////		assertThatDeleteDeliversErrorOnDeletionError(on: sut)
//	}
//
//	func test_delete_hasNoSideEffectsOnDeletionError() {
////		let sut = makeSUT()
////
////		assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
//	}
//
//}
