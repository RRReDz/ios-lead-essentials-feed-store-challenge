//
//  ObjectStoreFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Riccardo Rossi - Home on 22/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import ObjectBox

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

public class ObjectBoxFeedStore: FeedStore {
	private let storeURL: URL
	
	public init(storeURL: URL) {
		self.storeURL = storeURL
	}
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let store = try! Store(directoryPath: storeURL.path)
		
		let cache = Cache()
		cache.timestamp = timestamp
		
		let storeFeeds: [StoreFeed] = feed.map {
			let storeFeed = StoreFeed()
			storeFeed.modelId = $0.id.uuidString
			storeFeed.description = $0.description
			storeFeed.location = $0.location
			storeFeed.url = $0.url.absoluteString
			storeFeed.cache.target = cache
			return storeFeed
		}
		
		try! store.box(for: StoreFeed.self).put(storeFeeds)
		
		completion(nil)
	}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		let store = try! Store(directoryPath: storeURL.path)
		
		guard let cache = try! store.box(for: Cache.self).all().first else {
			return completion(.empty)
		}
		let localFeed = cache.feed.map {
			LocalFeedImage(
				id: UUID(uuidString: $0.modelId)!,
				description: $0.description,
				location: $0.location,
				url: URL(string: $0.url)!
			)
		}
		completion(.found(feed: localFeed, timestamp: cache.timestamp))
	}
}