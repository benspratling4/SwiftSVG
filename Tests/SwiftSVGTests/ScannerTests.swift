//
//  ScannerTests.swift
//  
//
//  Created by Ben Spratling on 5/15/20.
//

import Foundation
import XCTest
import SwiftGraphicsCore
@testable import SwiftSVG
//import SwiftPNG


class ScannerTests:XCTestCase {
	
	func testParsingAdjacentDoubles() {
		let string:String = "30.6, 24.7 10.4,28.2-37.2"
		let scanner:Scanner = Scanner(string: string)
		let doubles:[Float64] = scanner.scanDoublesUntilNoLongerScanable()
		XCTAssertEqual(doubles.count, 5)
		XCTAssertEqual(doubles[0], 30.6, accuracy:0.1)
		XCTAssertEqual(doubles[1], 24.7, accuracy:0.1)
		XCTAssertEqual(doubles[2], 10.4, accuracy:0.1)
		XCTAssertEqual(doubles[3], 28.2, accuracy:0.1)
		XCTAssertEqual(doubles[4], -37.2, accuracy:0.1)
		
	}

}
