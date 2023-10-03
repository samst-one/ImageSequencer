@testable import ImageSequencer
import UIKit
import CoreImage
import Foundation
import AVFoundation

class System {
    
    let assetWriterInput = SpyAssetWriterInput()
    let assetWriter = SpyAssetWriter()
    let assetWriterInputPixelBufferAdaptor = SpyAssetWriterInputPixelBufferAdaptor()
    let controller: DefaultImageSequencerController
    let canvas = SpyCanvas()
    
    let pixelBufferOperations = SpyPixelBufferController()
    
    init() {
        let startRenderUseCase = StartRenderUseCase(videoWriterInput: assetWriterInput, assetWriter: assetWriter)
        let finishRenderUseCase = FinishRenderUseCase(videoWriterInput: assetWriterInput, assetWriter: assetWriter)
        let renderImagesUseCase = RenderImagesUseCase(videoWriterInput: assetWriterInput,
                                                      pixelBufferAdaptor: assetWriterInputPixelBufferAdaptor,
                                                      renderSettings: RenderSettings(bitrate: 20,
                                                                                     size: CGSize(width: 1920,
                                                                                                  height: 1080),
                                                                                     fps: 30,
                                                                                     outputUrl: URL(filePath: "")),
                                                      pixelBufferController: pixelBufferOperations,
                                                      canvas: canvas)
        controller = DefaultImageSequencerController(startRenderUseCase: startRenderUseCase,
                                                     finishRenderUseCase: finishRenderUseCase,
                                                     renderImagesUseCase: renderImagesUseCase,
                                                     cancelRenderUseCase: CancelRenderUseCase(assetWriter: assetWriter))
    }
}

class SpyPixelBufferController: PixelBufferController {
    
    var returnNilPixelBuffer = false
    func create() -> CVPixelBuffer? {
        if returnNilPixelBuffer {
            return nil
        }
        var pxbuffer: CVPixelBuffer?
        let pixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: Int(1920),
            kCVPixelBufferHeightKey as String: Int(1080),
        ]
        CVPixelBufferCreate(kCFAllocatorDefault,
                            1920,
                            1080,
                            kCVPixelFormatType_32BGRA,
                            pixelBufferAttributes as CFDictionary,
                            &pxbuffer)
        return pxbuffer
    }
    
    func lock(pixelBuffer: CVPixelBuffer) {
        
    }
    
    func unlock(pixelBuffer: CVPixelBuffer) {
        
    }
    
    var statusToReturn = 0
    
    func status() -> Int {
        return statusToReturn
    }
}

class SpyCanvas: Canvas {
    func clear(_ frame: CGRect) {
        
    }
    
    var drawnImage: CIImage?
    var drawnRect: CGRect = .zero
    
    func draw(_ image: CIImage, in rect: CGRect) {
        drawnImage = image
        drawnRect = rect
    }
    
    var createdWidth = 0
    var createdHeight = 0
    var createdPixelBuffer: CVPixelBuffer?
    
    func create(width: Int, height: Int, pixelBuffer: CVPixelBuffer) {
        createdWidth = width
        createdHeight = height
        createdPixelBuffer = pixelBuffer
    }
}

class SpyAssetWriterInputPixelBufferAdaptor: AssetWriterInputPixelBufferAdaptor {
    var pixelBufferPool: CVPixelBufferPool? {
        var pixelBufferOut: CVPixelBufferPool?
        let poolAttributes = [kCVPixelBufferPoolMinimumBufferCountKey as String: 10000000000000]
        let pixelBufferAttributes: [String: Any] = [
                kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: Int(1920),
                kCVPixelBufferHeightKey as String: Int(1080),
            ]

        CVPixelBufferPoolCreate(kCFAllocatorDefault, poolAttributes as CFDictionary, pixelBufferAttributes as CFDictionary, &pixelBufferOut)
        return pixelBufferOut
    }
    
    var frameToAppend: CVPixelBuffer?
    func append(_ frame: CVPixelBuffer, withPresentationTime presentationTime: CMTime) {
        frameToAppend = frame
    }
}

class SpyAssetWriterInput: AssetWriterInput {
    var isReadyForMoreMediaData: Bool = true
    
    func requestMediaDataWhenReady(on queue: DispatchQueue, completion: @escaping () -> ()) {
        completion()
    }
    
    var markAsFinishedCalled = 0
    func markAsFinished() {
        markAsFinishedCalled += 1
    }
}

class SpyAssetWriter: AssetWriter {
    
    func canApply(outputSettings: [String : Any]) -> Bool {
        return false
    }
    
    var startWritingCalls = 0
    func startWriting() {
        startWritingCalls += 1
    }
    
    var startSessionCalls = 0
    func startSession() {
        startSessionCalls += 1
    }
    
    func finishWriting(completion: @escaping () -> ()) {
        completion()
    }
    
    var cancelWritingCalls = 0
    func cancelWriting() {
        cancelWritingCalls += 1
    }
}
