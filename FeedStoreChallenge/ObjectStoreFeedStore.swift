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
	private let store: Store
	private let queue: DispatchQueue
	
	private enum Error: Swift.Error {
		case parsingIntoLocal(param: String, value: String)
	}
	
	public init(storeURL: URL) throws {
		self.storeURL = storeURL
		self.store = try Store(directoryPath: storeURL.path)
		self.queue = DispatchQueue(label: "\(type(of: self))", qos: .userInitiated, attributes: .concurrent)
	}
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		queue.async(flags: .barrier) { [unowned self] in
			try! self.clearCache()
			completion(nil)
		}
	}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		queue.async(flags: .barrier) { [unowned self] in
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
			
			try! self.clearCache()
			try? self.store.box(for: StoreFeed.self).put(storeFeeds)
			
			completion(nil)
		}
	}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		queue.async { [unowned self] in
			do {
				guard let cache = getCache() else {
					return completion(.empty)
				}
				let localFeedStore = try ObjectBoxFeedStore.map(cache.feed)
				completion(.found(feed: localFeedStore, timestamp: cache.timestamp))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	// MARK: - Private
	
	private func clearCache() throws {
		try self.store.box(for: Cache.self).removeAll()
		try self.store.box(for: StoreFeed.self).removeAll()
	}
	
	private func getCache() -> Cache? {
		let cacheBox = store.box(for: Cache.self)
		return try? cacheBox.all().first
	}
	
	private static func map(_ storeFeed: ToMany<StoreFeed>) throws -> [LocalFeedImage] {
		let localFeed: [LocalFeedImage] = try storeFeed.map {
			guard let uuid = UUID(uuidString: $0.modelId) else {
				throw Error.parsingIntoLocal(param: "modelId", value: $0.modelId)
			}
			
			guard let url = URL(string: $0.url) else {
				throw Error.parsingIntoLocal(param: "url", value: $0.url)
			}
			
			return LocalFeedImage(
				id: uuid,
				description: $0.description,
				location: $0.location,
				url: url
			)
		}
		return localFeed
	}
}
