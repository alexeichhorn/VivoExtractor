import XCTest
@testable import VivoExtractor

final class VivoExtractorTests: XCTestCase {
    
    func testVideoURL(_ videoURL: URL) -> URL? {
        
        let expectation = self.expectation(description: "extraction")
        var url: URL?
        
        VivoExtractor.extract(fromURL: videoURL) { sourceURL in
            url = sourceURL
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
        return url
    }
    
    func testBunnyVideo() {
        let url = testVideoURL(URL(string: "https://vivo.sx/b36ee9e324")!)
        
        XCTAssertNotNil(url)
    }
    
    func testEmptyHTML() {
        let url = VivoExtractor.extract(fromHTML: "")
        XCTAssertNil(url)
    }
    
    func testUnavailableURL() {
        let url = testVideoURL(URL(string: "https://vivo.sx/abcdefghij")!)
        XCTAssertNil(url)
    }

    static var allTests = [
        ("testEmptyHTML", testEmptyHTML),
        ("testUnavailableURL", testUnavailableURL),
        ("testBunnyVideo", testBunnyVideo),
    ]
}
