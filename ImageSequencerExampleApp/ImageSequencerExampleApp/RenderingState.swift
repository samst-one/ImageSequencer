import Foundation

enum RenderingState: Equatable {
    case notRendering
    case creatingFrames(currentFrame: Int, total: Int)
    case rendering(percent: Double)
    case finished(videoUrl: URL)
    
    static func ==(lhs: RenderingState, rhs: RenderingState) -> Bool {
        switch (lhs, rhs) {
        case (.rendering, .rendering):
            return true
        case (.notRendering, .notRendering):
            return true
        case (.creatingFrames, .creatingFrames):
            return true
        case (.finished, .finished):
            return true
        default:
            return false
        }
    }
}
