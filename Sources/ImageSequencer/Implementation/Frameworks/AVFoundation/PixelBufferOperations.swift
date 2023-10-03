import AVFoundation

protocol PixelBufferController {
    func create() -> CVPixelBuffer?
    func lock(pixelBuffer: CVPixelBuffer)
    func unlock(pixelBuffer: CVPixelBuffer)
    func status() -> Int
}

class DefaultPixelBufferController: PixelBufferController {
    
    private var pixelBufferStatus: CVReturn = -1
    private var pixelBuffer: CVPixelBuffer?
    private let pixelBufferUnsafe: UnsafeMutablePointer<CVPixelBuffer?>
    private var pixelBufferPool: CVPixelBufferPool?
    private let pixelBufferAdapter: AVAssetWriterInputPixelBufferAdaptor
    
    init(_ pixelBufferAdapter: AVAssetWriterInputPixelBufferAdaptor, _ pixelBuffer: UnsafeMutablePointer<CVPixelBuffer?>) {
        self.pixelBufferAdapter = pixelBufferAdapter
        self.pixelBufferUnsafe = pixelBuffer
    }
    
    func create() -> CVPixelBuffer? {
        guard let pixelBufferPool = pixelBufferAdapter.pixelBufferPool else { return nil }
        var pixelBufferOut: CVPixelBuffer?
        pixelBufferStatus = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pixelBufferOut)
        return pixelBufferOut
    }
    
    func lock(pixelBuffer: CVPixelBuffer) {
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    }
    
    func unlock(pixelBuffer: CVPixelBuffer) {
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    }
  
    func status() -> Int {
        Int(pixelBufferStatus)
    }
}
