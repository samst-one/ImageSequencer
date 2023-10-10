import AVFoundation

protocol AssetWriter {
    func canApply(outputSettings: [String: Any]) -> Bool
    func startWriting()
    func startSession()
    func finishWriting(completion: @escaping () -> ())
    func cancelWriting()
    var outputUrl: URL { get }
}

class DefaultAssetWriter: AssetWriter {
    private let assetWriter: AVAssetWriter
    
    init(assetWriter: AVAssetWriter) {
        self.assetWriter = assetWriter
    }
    
    func canApply(outputSettings: [String: Any]) -> Bool {
        return assetWriter.canApply(outputSettings: outputSettings, forMediaType: .video)
    }
    
    func startWriting() {
        assetWriter.startWriting()
    }
    
    func startSession() {
        assetWriter.startSession(atSourceTime: .zero)
    }
    
    func finishWriting(completion: @escaping () -> ()) {
        assetWriter.finishWriting(completionHandler: completion)
    }
    
    func cancelWriting() {
        assetWriter.cancelWriting()
    }
    
    var outputUrl: URL {
        assetWriter.outputURL
    }
}
