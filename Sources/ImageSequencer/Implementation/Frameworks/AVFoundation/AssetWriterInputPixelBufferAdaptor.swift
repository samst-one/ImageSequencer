import AVFoundation

protocol AssetWriterInputPixelBufferAdaptor {
    var pixelBufferPool: CVPixelBufferPool? { get }
    func append(_ frame: CVPixelBuffer, withPresentationTime presentationTime: CMTime)
}

class DefaultAssetWriterInputPixelBufferAdaptor: AssetWriterInputPixelBufferAdaptor {

    var pixelBufferPool: CVPixelBufferPool? {
        pixelBufferAdaptor.pixelBufferPool
    }
    
    private let pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor
    
    init(pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor) {
        self.pixelBufferAdaptor = pixelBufferAdaptor
    }
    
    func append(_ frame: CVPixelBuffer, withPresentationTime presentationTime: CMTime) {
        pixelBufferAdaptor.append(frame, withPresentationTime: presentationTime)
    }
}
