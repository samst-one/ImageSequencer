import SwiftUI

class ViewModel: ObservableObject {
    @Published var fps: Int = 24
    @Published var bitrate: Int = 2000000
    @Published var height: Int = 2160
    @Published var width: Int = 3840
    @Published var numberOfFrames: Int = 100
    @Published var renderingState: RenderingState = .notRendering
}
