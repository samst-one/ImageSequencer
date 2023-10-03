@testable import ImageSequencer
import XCTest

class PixelBufferAttributesTests: XCTestCase {
    
    func test() {
        let dict = PixelBufferAttributes.from(RenderSettings(bitrate: 1000, size: CGSize(width: 100, height: 200), fps: 32, outputUrl: URL(filePath: "")))
        XCTAssertEqual(dict["PixelFormatType"] as! Int, 32)
        XCTAssertEqual(dict["Width"] as! Int, 100)
        XCTAssertEqual(dict["Height"] as! Int, 200)
    }
}
