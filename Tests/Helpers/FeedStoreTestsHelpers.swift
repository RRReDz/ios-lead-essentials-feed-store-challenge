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
	
	func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
		addTeardownBlock { [weak instance] in
			XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
		}
	}
}
