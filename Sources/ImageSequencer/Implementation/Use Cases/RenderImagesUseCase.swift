import AVFoundation
import CoreImage

class RenderImagesUseCase {
    
    private let videoWriterInput: AssetWriterInput
    private let pixelBufferAdaptor: AssetWriterInputPixelBufferAdaptor
    private let renderSettings: RenderSettings
    private let pixelBufferController: PixelBufferController
    private let canvas: Canvas
    
    init(videoWriterInput: AssetWriterInput,
         pixelBufferAdaptor: AssetWriterInputPixelBufferAdaptor,
         renderSettings: RenderSettings,
         pixelBufferController: PixelBufferController,
         canvas: Canvas) {
        self.videoWriterInput = videoWriterInput
        self.pixelBufferAdaptor = pixelBufferAdaptor
        self.renderSettings = renderSettings
        self.pixelBufferController = pixelBufferController
        self.canvas = canvas
    }
    
    func render(images: [URL], didAddFrame: @escaping (Double) -> (), completion: @escaping (Error?) -> ()) {
        let queue = DispatchQueue(label: "mediaInputQueue")

        videoWriterInput.requestMediaDataWhenReady(on: queue) {
            for (index, image) in images.enumerated() {
                while !(self.videoWriterInput.isReadyForMoreMediaData) {}
                do {
                    try self.addFrame(frameNumber: index, image: image)
                    didAddFrame((Double(index) / Double(images.count)) * 100)
                } catch let error {
                    completion(error)
                    return
                }
            }
            completion(nil)
        }
    }
    
    private func addFrame(frameNumber: Int, image: URL) throws {
        let frameDuration = CMTimeMake(value: Int64(600 / renderSettings.fps),
                                       timescale: 600)
        let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameNumber))
        
        if let image = CIImage(contentsOf: image, options: [.applyOrientationProperty: true]) {
            switch self.create(image: image) {
            case .success(let pixelBuffer):
                pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
            case .failure(let error):
                throw error
            }
        } else {
            throw RenderingError.couldntFindImage
        }
    }
    
    func create(image: CIImage) -> Result<CVPixelBuffer, RenderingError>  {
        guard let pixelBuffer = pixelBufferController.create() else {
            return .failure(.couldntCreatePixelBuffer)
        }
        
        if pixelBufferController.status() != kCVReturnSuccess {
            return .failure(.pixelBufferHasFailed)
        }
        
        pixelBufferController.lock(pixelBuffer: pixelBuffer)

        canvas.create(width: Int(renderSettings.size.width), height: Int(renderSettings.size.height), pixelBuffer: pixelBuffer)
        
        canvas.clear(CGRect(x: 0, y: 0, width: renderSettings.size.width, height: renderSettings.size.height))
        
        let newSize = getFrame(frameSize: renderSettings.size, imageSize: image.extent.size)
        let position = getPosition(newSize: newSize, frameSize: renderSettings.size)
        
        canvas.draw(image, in: CGRect(x: position.x, y: position.y, width: newSize.width, height: newSize.height))
        
        pixelBufferController.unlock(pixelBuffer: pixelBuffer)

        return .success(pixelBuffer)
    }
    
    private func getPosition(newSize: CGSize, frameSize: CGSize) -> CGPoint {
        let x = newSize.width < frameSize.width ? (frameSize.width - newSize.width) / 2 : 0
        let y = newSize.height < frameSize.height ? (frameSize.height - newSize.height) / 2 : 0
        
        return CGPoint(x: x, y: y)
    }
    
    private func getFrame(frameSize: CGSize, imageSize: CGSize) -> CGSize {
        let horizontalRatio = frameSize.width / imageSize.width
        let verticalRatio = frameSize.height / imageSize.height
        
        let aspectRatio = min(horizontalRatio, verticalRatio)
        
        return CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
    }
}

enum RenderingError: Error, LocalizedError {
    case couldntCreatePixelBuffer
    case pixelBufferHasFailed
    case couldntFindImage
}
