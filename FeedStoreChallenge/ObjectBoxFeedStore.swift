//
//  ObjectBoxFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Riccardo Rossi - Home on 22/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import ObjectBox

typealias StoreFeed = ObjectBoxFeedStore.StoreFeed
typealias Cache = ObjectBoxFeedStore.Cache

public class ObjectBoxFeedStore: FeedStore {
	
	// MARK: - Inner classes & enums
	
	class StoreFeed: Entity {
		var id: Id = 0
		var modelId: String = ""
		var description: String?
		var location: String?
		var url: String = ""
		var cache: ToOne<Cache> = nil
		
		init(modelId: String = "", description: String? = nil, location: String? = nil, url: String = "", cache: Cache? = nil) {
			self.modelId = modelId
			self.description = description
			self.location = location
			self.url = url
			self.cache.target = cache
		}
	}
	
	class Cache: Entity {
		var id: Id = 0
		var timestamp: Double
		// objectbox: backlink = "cache"
		var feed: ToMany<StoreFeed> = nil
		
		init(timestamp: Double = 0.0) {
			self.timestamp = timestamp
		}
	}
	
	private enum Error: Swift.Error {
		case parsingIntoLocal(param: String, value: String)
	}
	
	// MARK: - Private properties
	
	private let storeURL: URL
	private let store: Store
	private let queue: DispatchQueue
	
	// MARK: - Public init & methods
	
	public init(storeURL: URL) throws {
		self.storeURL = storeURL
		self.store = try Store(directoryPath: storeURL.path)
		self.queue = DispatchQueue(label: "\(type(of: self))", qos: .userInitiated, attributes: .concurrent)
	}
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		queue.async(flags: .barrier) { [weak self] in
			guard let self = self else { return }
			do {
				try self.clearCache()
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		queue.async(flags: .barrier) { [weak self] in
			guard let self = self else { return }
			do {
				try self.clearCache()
				
				let cache = Cache(timestamp: timestamp.timeIntervalSinceReferenceDate)
				let storeFeeds: [StoreFeed] = feed.toStore(with: cache)
				try self.setCache(storeFeeds: storeFeeds)
				
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		queue.async { [weak self] in
			guard let self = self else { return }
			do {
				guard let cache = try self.getCache() else {
					return completion(.empty)
				}
				let localFeedStore = try ObjectBoxFeedStore.map(cache.feed)
				let dateTimestamp = Date(timeIntervalSinceReferenceDate: cache.timestamp)
				
				completion(.found(feed: localFeedStore, timestamp: dateTimestamp))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	// MARK: - Private methods
	
	private func clearCache() throws {
		try self.store.box(for: Cache.self).removeAll()
		try self.store.box(for: StoreFeed.self).removeAll()
	}
	
	private func setCache(storeFeeds: [StoreFeed]) throws {
		try self.store.box(for: StoreFeed.self).put(storeFeeds)
	}
	
	private func getCache() throws -> Cache? {
		let cacheBox = store.box(for: Cache.self)
		return try cacheBox.all().first
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

// MARK: Private extensions

private extension Array where Element == LocalFeedImage {
	func toStore(with cache: Cache) -> [StoreFeed] {
		self.map {
			return StoreFeed(
				modelId: $0.id.uuidString,
				description: $0.description,
				location: $0.location,
				url: $0.url.absoluteString,
				cache: cache
			)
		}
	}
}
