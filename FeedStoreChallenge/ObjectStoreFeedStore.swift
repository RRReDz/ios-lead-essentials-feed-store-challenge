//
//  ObjectStoreFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Riccardo Rossi - Home on 22/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public class ObjectBoxFeedStore: FeedStore {
	public init() {}
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		completion(.empty)
	}
}
