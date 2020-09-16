//
//  ConvenienceFunctionTests.swift
//  LoveQuick_UIKitTests
//
//  Created by Jonathan Lasley on 9/8/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import XCTest
@testable import LoveQuick_UIKit

class ConvenienceFunctionTests: XCTestCase {

	
	var time: Int!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		super.setUp()
		time = 3548
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
		time = nil
    }

    func testConversion() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		let format = convertSecondsToFormattedTime(seconds: time)
		XCTAssertEqual(format, "59:08")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
