import CoreImage

protocol Canvas {
    func clear(_ frame: CGRect)
    func draw(_ image: CIImage, in rect: CGRect)
    func create(width: Int, height: Int, pixelBuffer: CVPixelBuffer)
}

class DefaultCanvas: Canvas {
    
    private var context: CGContext?
    
    func create(width: Int, height: Int, pixelBuffer: CVPixelBuffer) {
        context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer),
                            width: width,
                            height: height,
                            bitsPerComponent: 8,
                            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
    }
    
    func clear(_ frame: CGRect) {
        context?.clear(frame)
    }
    
    func draw(_ image: CIImage, in rect: CGRect) {
        guard let cgImage = convertCIImageToCGImage(inputImage: image) else {
            return
        }
        autoreleasepool {
            context?.draw(cgImage, in: rect)
        }
    }
    
    private func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        if let cgImage = CIContext(options: nil).createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
}
