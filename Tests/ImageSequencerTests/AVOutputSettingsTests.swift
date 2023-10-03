import XCTest
@testable import ImageSequencer
import AVFoundation

class AVOutputSettingsTests: XCTestCase {
    
    func testAvOutputSettingsCreatedCorrectly() {
        let dict = OutputSettings.from(RenderSettings(bitrate: 1000, size: CGSize(width: 100, height: 200), fps: 32, outputUrl: URL(filePath: "")))
        XCTAssertEqual(dict["AVVideoCodecKey"] as! AVVideoCodecType, .h264)
        XCTAssertEqual(dict["AVVideoWidthKey"] as! NSNumber, 100)
        XCTAssertEqual(dict["AVVideoHeightKey"] as! NSNumber, 200)
        XCTAssertEqual((dict["AVVideoCompressionPropertiesKey"] as! [String: Any])["AverageBitRate"] as! Int, 1000000)
        XCTAssertEqual((dict["AVVideoCompressionPropertiesKey"] as! [String: Any])["ProfileLevel"] as! String, "H264_High_AutoLevel")
    }
}
