//
//  StdFileSystemTests.swift
//  StdFileSystem
//
//  Created by Bernardo Breder.
//
//

import XCTest
@testable import StdFileSystemTests

extension StdFileSystemTests {

	static var allTests : [(String, (StdFileSystemTests) -> () throws -> Void)] {
		return [
			("testExist", testExist),
			("testList", testList),
			("testPath", testPath),
		]
	}

}

XCTMain([
	testCase(StdFileSystemTests.allTests),
])

