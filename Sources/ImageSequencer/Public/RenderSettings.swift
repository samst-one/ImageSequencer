import Foundation

public class RenderSettings {
    
    public let bitrate: Int
    public let size: CGSize
    public let fps: Int32
    public let outputUrl: URL

    public init(bitrate: Int,
                size: CGSize,
                fps: Int32,
                outputUrl: URL) {
        self.bitrate = bitrate
        self.size = size
        self.fps = fps
        self.outputUrl = outputUrl
    }
}
