import AVKit
import ImageSequencer

class Presenter {
    
    private var view: Viewable?
    
    func didTapMakeImages(fps: Int,
                          bitrate: Int,
                          height: Int,
                          width: Int,
                          numberOfFrames: Int) {
        DispatchQueue.global(qos: .userInteractive).async {
            let images = GenerateImages.generate(with: CGSize(width: width,
                                                              height: height),
                                                 numberOfImages: numberOfFrames,
                                                 frameGenerated: { index in
                DispatchQueue.main.async {
                    self.view?.didUpdateRenderingState(state: .creatingFrames(currentFrame: index, total: numberOfFrames))
                }
            })
            
            let outputUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(UUID().uuidString).mp4")
            let controller = try? ImageSequencerFactory.make(settings: RenderSettings(bitrate: bitrate,
                                                                                      size: CGSize(width: width,
                                                                                                   height: height),
                                                                                      fps: Int32(fps),
                                                                                      outputUrl: outputUrl))
            controller?.start()
            DispatchQueue.main.async {
                self.view?.didUpdateRenderingState(state: .rendering(percent: 0))
            }
            controller?.render(images:  images) { percent in
                DispatchQueue.main.async {
                    self.view?.didUpdateRenderingState(state: .rendering(percent: percent))
                }
            } completion: { error in
                if error == nil {
                    controller?.finish {
                        DispatchQueue.main.async {
                            self.view?.didUpdateRenderingState(state: .finished(videoUrl: outputUrl))
                        }
                    }
                }
            }
        }
    }
    
    func set(_ view: Viewable) {
        self.view = view
    }
}
