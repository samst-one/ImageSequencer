import Foundation

class StartRenderUseCase {

    private let videoWriterInput: AssetWriterInput
    private let assetWriter: AssetWriter

    init(videoWriterInput: AssetWriterInput,
         assetWriter: AssetWriter) {
        self.videoWriterInput = videoWriterInput
        self.assetWriter = assetWriter
    }
    
    func start() {
        assetWriter.startWriting()
        assetWriter.startSession()
    }
}
