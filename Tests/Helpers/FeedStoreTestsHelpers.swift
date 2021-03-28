//
//  FeedStoreTestsHelpers.swift
//  Tests
//
//  Created by Riccardo Rossi - Home on 28/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
	func specificURLForTest() -> URL {
		return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
	}
	
	func deleteStoreArtifacts() {
		try? FileManager.default.removeItem(at: specificURLForTest())
	}
}