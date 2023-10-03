import CoreImage

enum PixelBufferAttributes {
    static func from(_ settings: RenderSettings) -> [String : Any] {
        return [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: NSNumber(value: Float(settings.size.width)),
            kCVPixelBufferHeightKey as String: NSNumber(value: Float(settings.size.height))
        ]
    }
}
