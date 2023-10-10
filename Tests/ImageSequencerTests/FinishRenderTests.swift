@testable import ImageSequencer
import XCTest

class FinishRenderTests: XCTestCase {
    
    func testWhenUserFinishesARender_ThenRenderIsFinished () {
        let expectation = self.expectation(description: "Waiting for finish")
        let system = System()
        system.controller.finish { outputUrl in
            XCTAssertEqual(outputUrl, URL(string: "https://www.google.com"))
            XCTAssert(true)
            XCTAssertEqual(system.assetWriterInput.markAsFinishedCalled, 1)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 0.1)
    }
    
    
}
