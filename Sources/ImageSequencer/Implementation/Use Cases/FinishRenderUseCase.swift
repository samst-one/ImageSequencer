import Foundation

class FinishRenderUseCase {
    
    private let videoWriterInput: AssetWriterInput
    private let assetWriter: AssetWriter

    init(videoWriterInput: AssetWriterInput,
         assetWriter: AssetWriter) {
        self.videoWriterInput = videoWriterInput
        self.assetWriter = assetWriter
    }
    
    func finish(completion: @escaping (URL) -> ()) {
        videoWriterInput.markAsFinished()
        assetWriter.finishWriting() {
            DispatchQueue.main.async {
                completion(self.assetWriter.outputUrl)
            }
        }
    }
}
