import XCTest
@testable import ImageSequencer

final class StartRenderTests: XCTestCase {
    
    func testWhenUserStartsRender_ThenRenderIsStarted () {
        let system = System()
        system.controller.start()
        
        XCTAssertEqual(system.assetWriter.startSessionCalls, 1)
        XCTAssertEqual(system.assetWriter.startWritingCalls, 1)
    }
}
