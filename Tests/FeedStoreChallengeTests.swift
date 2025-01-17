//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge
import ObjectBox

class FeedStoreChallengeTests: XCTestCase, FeedStoreSpecs {
	
	override func setUp() {
		deleteStoreArtifacts()
	}

	override func tearDown() {
		deleteStoreArtifacts()
	}
	
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
	
	func test_retrieve_deliversEmptyOnEmptyCache() throws {
		let sut = try makeSUT()
		
		assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
	}
	
	func test_retrieve_hasNoSideEffectsOnEmptyCache() throws {
		let sut = try makeSUT()

		assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
	}
	
	func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws {
		let sut = try makeSUT()

		assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
	}
	
	func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws {
		let sut = try makeSUT()

		assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
	}
	
	func test_insert_deliversNoErrorOnEmptyCache() throws {
		let sut = try makeSUT()

		assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
	}
	
	func test_insert_deliversNoErrorOnNonEmptyCache() throws {
		let sut = try makeSUT()

		assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
	}
	
	func test_insert_overridesPreviouslyInsertedCacheValues() throws {
		let sut = try makeSUT()

		assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
	}
	
	func test_delete_deliversNoErrorOnEmptyCache() throws {
		let sut = try makeSUT()

		assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
	}
	
	func test_delete_hasNoSideEffectsOnEmptyCache() throws {
		let sut = try makeSUT()

		assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
	}
	
	func test_delete_deliversNoErrorOnNonEmptyCache() throws {
		let sut = try makeSUT()

		assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
	}
	
	func test_delete_emptiesPreviouslyInsertedCache() throws {
		let sut = try makeSUT()

		assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
	}
	
	func test_storeSideEffects_runSerially() throws {
		let sut = try makeSUT()

		assertThatSideEffectsRunSerially(on: sut)
	}
	
	// - MARK: Helpers
	
	private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) throws -> FeedStore {
		let sut = try ObjectBoxFeedStore(storeURL: storeURL ?? specificURLForTest())
		trackForMemoryLeaks(sut, file: file, line: line)
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

class Cache: Entity {
	var id: Id = 0
	var timestamp: Date = Date()
	// objectbox: backlink = "cache"
	var feed: ToMany<StoreFeed> = nil
}

class StoreFeed: Entity {
	var id: Id = 0
	var modelId: String = ""
	var description: String?
	var location: String?
	var url: String = ""
	var cache: ToOne<Cache> = nil
}

extension FeedStoreChallengeTests: FailableRetrieveFeedStoreSpecs {
	
	private func addInvalidFormattedFeedTo(storeURL: URL) throws {
		let store = try Store(directoryPath: storeURL.path)
		let cache = Cache()
		cache.timestamp = Date()

		let storeFeed = StoreFeed()
		storeFeed.modelId = "Invalid UUID"
		storeFeed.description = "A description"
		storeFeed.location = "A location"
		storeFeed.url = "Invalid URL"
		storeFeed.cache.target = cache

		try store.box(for: StoreFeed.self).put(storeFeed)
	}

	func test_retrieve_deliversFailureOnRetrievalError() throws {
		let storeURL = specificURLForTest()
		let sut = try makeSUT(storeURL: storeURL)
		
		try addInvalidFormattedFeedTo(storeURL: storeURL)

		assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnFailure() throws {
		let storeURL = specificURLForTest()
		let sut = try makeSUT(storeURL: storeURL)
		
		try addInvalidFormattedFeedTo(storeURL: storeURL)

		assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
	}

}
