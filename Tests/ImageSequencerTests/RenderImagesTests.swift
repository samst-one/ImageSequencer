@testable import ImageSequencer
import XCTest

class RenderImagesTests: XCTestCase {
    
    let system = System()
    
    func testWhenImageWithCorrectAspectRatioIsInputted_ThenCorrectFrameIsRendered() {
        let expecation = self.expectation(description: "")
        
        let imageURL = Bundle.module.url(forResource: "cat_1080", withExtension: "jpeg")!

        
        system.controller.render(images: [imageURL]) { _ in} completion: { _ in
            let buffer = self.system.assetWriterInputPixelBufferAdaptor.frameToAppend!

            XCTAssertEqual(self.system.canvas.createdHeight, 1080)
            XCTAssertEqual(self.system.canvas.createdWidth, 1920)
            XCTAssertEqual(self.system.canvas.createdPixelBuffer, buffer)
            
            let ciContext = CIContext()
         
            XCTAssertEqual(self.system.canvas.drawnRect, CGRect(x: 0, y: 0, width: 1920, height: 1080))
            XCTAssertEqual(ciContext.jpegRepresentation(of: self.system.canvas.drawnImage!, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, options: [:]),
                           ciContext.jpegRepresentation(of: CIImage(contentsOf: imageURL)!, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, options: [:]) )

            expecation.fulfill()
        }

        self.wait(for: [expecation], timeout: 0.1)
    }
    
    func testWhenImageWithPortraitAspectRatioIsInputted_ThenCorrectFrameIsRendered() {
        let expecation = self.expectation(description: "")
        
        let imageURL = Bundle.module.url(forResource: "cat_1080_portrait", withExtension: "jpeg")!

        system.controller.render(images: [imageURL]) { _ in } completion: { _ in
            let buffer = self.system.assetWriterInputPixelBufferAdaptor.frameToAppend!

            XCTAssertEqual(self.system.canvas.createdHeight, 1080)
            XCTAssertEqual(self.system.canvas.createdWidth, 1920)
            XCTAssertEqual(self.system.canvas.createdPixelBuffer, buffer)
            
            let ciContext = CIContext()
         
            XCTAssertEqual(self.system.canvas.drawnRect, CGRect(x: 656.25, y: 0, width: 607.5, height: 1080))
            XCTAssertEqual(ciContext.jpegRepresentation(of: self.system.canvas.drawnImage!, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, options: [:]),
                           ciContext.jpegRepresentation(of: CIImage(contentsOf: imageURL, options: [.applyOrientationProperty: true])!, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, options: [:]) )

            expecation.fulfill()
        }

        self.wait(for: [expecation], timeout: 0.1)
    }
    
    func testWhenPixelBufferCantBeCreated_ThenErrorIsReturned() {
        let expecation = self.expectation(description: "")
        
        let imageURL = Bundle.module.url(forResource: "cat_1080_portrait", withExtension: "jpeg")!
        system.pixelBufferOperations.returnNilPixelBuffer = true
        system.controller.render(images: [imageURL]) { _ in } completion: { error in
            XCTAssertEqual(error as! RenderingError, RenderingError.couldntCreatePixelBuffer)
            expecation.fulfill()
        }
        self.wait(for: [expecation], timeout: 0.1)
    }
    
    func testWhenPixelBufferStatusIsntSuccessfullyCreated_ThenErrorIsReturned() {
        let expecation = self.expectation(description: "")
        
        let imageURL = Bundle.module.url(forResource: "cat_1080_portrait", withExtension: "jpeg")!
        system.pixelBufferOperations.statusToReturn = 10
        system.controller.render(images: [imageURL]) { _ in } completion: { error in
            XCTAssertEqual(error as! RenderingError, RenderingError.pixelBufferHasFailed)
            expecation.fulfill()
        }
        self.wait(for: [expecation], timeout: 0.1)
    }
    
    func testWhenImageCantBeFound_ThenErrorIsReturned() {
        let expecation = self.expectation(description: "")
        
        let imageURL = URL(filePath: "image_doesnt_exist")
        
        system.controller.render(images: [imageURL]) { _ in } completion: { error in
            XCTAssertEqual(error as! RenderingError, RenderingError.couldntFindImage)
            expecation.fulfill()
        }
        self.wait(for: [expecation], timeout: 0.1)
    }
    
    func testWhenFrameHasBeenAdded_ThenDidUpdateCompletionCalledWithCorrectPercentage() {
        let expecation = self.expectation(description: "")
        
        let imageURL = Bundle.module.url(forResource: "cat_1080_portrait", withExtension: "jpeg")!
        
        var progressCalled = 0.0
        
        system.controller.render(images: [imageURL, imageURL, imageURL]) { progress in
            XCTAssertEqual(progress, (progressCalled / 3.0) * 100.0)
            progressCalled += 1
            if progressCalled == 2 {
                expecation.fulfill()
            }
        } completion: { _ in }

        self.wait(for: [expecation], timeout: 0.1)
    }
    
}
