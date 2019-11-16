import XCTest
@testable import VivoExtractor

final class VivoExtractorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(VivoExtractor().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
