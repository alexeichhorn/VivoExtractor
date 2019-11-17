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
    
    func testSourceDecoder() {
        let encoded = #"9EEADi%5E%5E%3F%4056%5C%5C46%3D%3A2%5DG%3AG%40%5DDI%5EG%405%5E%21pcc%22_%27h6F%7C6Cwup%239b%27%7Bp%5E%60dfbhdcgcf%5E_____b%60%60hd"#
        let url = VivoExtractor.extract(fromEncodedSource: encoded)
        
        XCTAssertEqual(url, URL(string: "https://node--celia.vivo.sx/vod/PA44Q0V9euMerHFARh3VLA/1573954847/0000031195"))
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
        ("testBunnyVideo", testBunnyVideo),
        ("testSourceDecoder", testSourceDecoder)
        ("testEmptyHTML", testEmptyHTML),
        ("testUnavailableURL", testUnavailableURL),
    ]
}
