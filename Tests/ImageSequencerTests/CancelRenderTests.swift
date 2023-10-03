@testable import ImageSequencer
import XCTest

class CancelRenderTests: XCTestCase {
    
    func testWhenUserCancelsRender_ThenRenderIsCancelled() {
        let system = System()
        system.controller.cancel()
        
        XCTAssertEqual(system.assetWriter.cancelWritingCalls, 1)
    }
}
