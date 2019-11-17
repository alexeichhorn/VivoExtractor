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
    
    func testHTMLExtraction() {
        let html = """
            <script>
            Core.InitializeStream ({
                quality: 0,
                source: '9EEADi%5E%5E%3F%4056%5C%5C46%3D%3A2%5DG%3AG%40%5DDI%5EG%405%5ErwvueaeHx%7D7%3D28%7C%28sK%24sf8%5E%60dfbhdcdce%5E_____b%60%60hd',
                restricting: 0,
                preroll: '9EEADi%5E%5EDJ%3F5%3A42E%3A%40%3F%5D6I5J%3FDCG%5D4%40%3E%5EDA%3D2D9%5DA9An%3A5K%40%3F6lbb_hac_',
                targets: {"9EEADi%5E%5EC%40EF%3E2%3D%5D4%40%3E%5Ec%5Ehb%60db%60":0.5,"9EEADi%5E%5EHHH%5D64A%3ED%5D%3F6E%5EA9e_%3EaI%3EeAn%3C6Jl_7f532_6gh5dada623gd2egga472df62":0.4,"9EEADi%5E%5EDJ%3F5%3A42E%3A%40%3F%5D6I5J%3FDCG%5D4%40%3E%5EDA%3D2D9%5DA9An42ElU%3A5K%40%3F6lbachfccUEJA6lg":0.1}    });
        """
        let url = VivoExtractor.extract(fromHTML: html)
        
        XCTAssertEqual(url, URL(string: "https://node--celia.vivo.sx/vod/CHGF626wINflagMWDzSD7g/1573954546/0000031195"))
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
        ("testSourceDecoder", testSourceDecoder),
        ("testHTMLExtraction", testHTMLExtraction),
        ("testEmptyHTML", testEmptyHTML),
        ("testUnavailableURL", testUnavailableURL),
    ]
}
