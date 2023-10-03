import AVFoundation

protocol AssetWriterInput {
    var isReadyForMoreMediaData: Bool { get }
    func requestMediaDataWhenReady(on queue: DispatchQueue, completion: @escaping () -> ())
    func markAsFinished()
}

class DefaultAssetWriterInput: AssetWriterInput {
    var isFinished: Bool = false
    
    private let videoWriterInput: AVAssetWriterInput
    
    var isReadyForMoreMediaData: Bool {
        videoWriterInput.isReadyForMoreMediaData
    }

    init(videoWriterInput: AVAssetWriterInput) {
        self.videoWriterInput = videoWriterInput
    }
    
    func requestMediaDataWhenReady(on queue: DispatchQueue, completion: @escaping () -> ()) {
        videoWriterInput.requestMediaDataWhenReady(on: queue, using: completion)
    }
    
    func markAsFinished() {
        videoWriterInput.markAsFinished()
    }
}
