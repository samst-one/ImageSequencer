import Foundation

class CancelRenderUseCase {
    
    private let assetWriter: AssetWriter
    
    init(assetWriter: AssetWriter) {
        self.assetWriter = assetWriter
    }
    
    func cancel() {
        assetWriter.cancelWriting()
    }
}
