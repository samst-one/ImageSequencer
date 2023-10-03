import AVFoundation

enum OutputSettings {
    static func from(_ settings: RenderSettings) -> [String : Any] {
        return [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: NSNumber(value: Float(settings.size.width)),
            AVVideoHeightKey: NSNumber(value: Float(settings.size.height)),
            AVVideoCompressionPropertiesKey:
                [
                    AVVideoAverageBitRateKey: settings.bitrate * 1000,
                    AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
                ],
        ]
    }
}
