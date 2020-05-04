import XCTest
@testable import SwiftSVG

final class SwiftSVGTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftSVG().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
