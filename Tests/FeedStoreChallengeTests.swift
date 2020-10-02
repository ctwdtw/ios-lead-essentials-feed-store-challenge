//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge
import RealmSwift

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
    
    private var strongRealmReference: RealmSwift.Realm?
    
    override func setUp() {
        super.setUp()
        setupRealmStrongReference()
    }
    
    override func tearDown() {
        super.tearDown()
        undoRealmSideEffects()
    }
    
    private func setupRealmStrongReference() {
        strongRealmReference = try! RealmSwift.Realm(configuration: unitTestRealmConfiguration())
    }
    
    private func undoRealmSideEffects() {
        strongRealmReference = nil
    }
    
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
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        
        assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        
        assertThatSideEffectsRunSerially(on: sut)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(factory: RealmFeedStore.RealmFactory? = nil) -> FeedStore {
        let f = factory == nil ? defaultRealmFactory() : factory!
        let sut = RealmFeedStore (factory: f)
        return sut
    }
    
    private func defaultRealmFactory() -> RealmFeedStore.RealmFactory {
        return {
            try! RealmSwift.Realm(configuration: self.unitTestRealmConfiguration())
        }
    }
    
    private func unitTestRealmConfiguration() -> RealmSwift.Realm.Configuration {
        return RealmSwift.Realm.Configuration(inMemoryIdentifier: "UnitTestInMemoryRealm")
    }
    
}

//  ***********************
//
//  Uncomment the following tests if your implementation has failable operations.
//
//  Otherwise, delete the commented out code!
//
//  ***********************


extension FeedStoreChallengeTests: FailableRetrieveFeedStoreSpecs {
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let sut = makeSUT { throw self.anyNSError() }
        
        assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let sut = makeSUT { throw self.anyNSError() }
        
        assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
    }
    
}

extension FeedStoreChallengeTests: FailableInsertFeedStoreSpecs {
    
    func test_insert_deliversErrorOnInsertionError() {
        let sut = makeSUT {
            let realm = try! (self.defaultRealmFactory())()
            return RealmErrorStub(realm: realm, stubbedError: self.anyNSError())
        }
        
        assertThatInsertDeliversErrorOnInsertionError(on: sut)
    }
    
    func test_insert_deliversErrorOnRealmInitError() {
        let sut = makeSUT {
            throw self.anyNSError()
        }
        
        assertThatInsertDeliversErrorOnInsertionError(on: sut)
    }
    
    func test_insert_hasNoSideEffectsOnInsertionError() {
        let sut = makeSUT {
            let realm = try! (self.defaultRealmFactory())()
            return RealmErrorStub(realm: realm, stubbedError: self.anyNSError())
        }
        
        assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
    }
    
}

extension FeedStoreChallengeTests: FailableDeleteFeedStoreSpecs {
    
    func test_delete_deliversErrorOnDeletionError() {
        let sut = makeSUT {
            let realm = try! (self.defaultRealmFactory())()
            return RealmErrorStub(realm: realm, stubbedError: self.anyNSError())
        }
        
        assertThatDeleteDeliversErrorOnDeletionError(on: sut)
    }
    
    func test_delete_deliversErrorOnRealmInitError() {
        let sut = makeSUT {
            throw self.anyNSError()
        }
        
        assertThatDeleteDeliversErrorOnDeletionError(on: sut)
    }
    
    func test_delete_hasNoSideEffectsOnDeletionError() {
        let sut = makeSUT()
        
        assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
    }
    
}

//MARK: - test doubles
private class RealmErrorStub: FeedStoreChallenge.Realm {
    private let realm: FeedStoreChallenge.Realm
    private let stubbedError: Error
    
    init(realm: FeedStoreChallenge.Realm, stubbedError: Error) {
        self.realm = realm
        self.stubbedError = stubbedError
    }
    
    func add(_ object: Object, update: RealmSwift.Realm.UpdatePolicy) {
        realm.add(object, update: update)
    }
    
    func objects<Element>(_ type: Element.Type) -> Results<Element> where Element : Object {
        return realm.objects(type)
    }
    
    func deleteAll() {
        realm.deleteAll()
    }
    
    func write<Result>(withoutNotifying tokens: [NotificationToken], _ block: (() throws -> Result)) throws -> Result {
        throw stubbedError
    }
    
}
