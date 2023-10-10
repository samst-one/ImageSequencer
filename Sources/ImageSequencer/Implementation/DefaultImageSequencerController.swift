import Foundation

class DefaultImageSequencerController: ImageSequencerController {
    
    private let startRenderUseCase: StartRenderUseCase
    private let finishRenderUseCase: FinishRenderUseCase
    private let renderImagesUseCase: RenderImagesUseCase
    private let cancelRenderUseCase: CancelRenderUseCase
    
    init(startRenderUseCase: StartRenderUseCase,
         finishRenderUseCase: FinishRenderUseCase,
         renderImagesUseCase: RenderImagesUseCase,
         cancelRenderUseCase: CancelRenderUseCase) {
        self.startRenderUseCase = startRenderUseCase
        self.finishRenderUseCase = finishRenderUseCase
        self.renderImagesUseCase = renderImagesUseCase
        self.cancelRenderUseCase = cancelRenderUseCase
    }
    
    func render(images: [URL], didAddFrame: @escaping (Double) -> (), completion: @escaping (Error?) -> ()) {
        renderImagesUseCase.render(images: images) { percent in
            DispatchQueue.main.async {
                didAddFrame(percent)
            }
        } completion: { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func start() {
        startRenderUseCase.start()
    }
    
    func finish(completion: @escaping (URL) -> ()) {
        finishRenderUseCase.finish(completion: completion)
    }
    
    func cancel() {
        cancelRenderUseCase.cancel()
    }
}
