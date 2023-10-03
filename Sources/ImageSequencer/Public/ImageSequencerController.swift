import Foundation

public protocol ImageSequencerController {
    func start()
    func finish(completion: @escaping () -> ())
    func render(images: [URL],
                didAddFrame: @escaping (Double) -> (),
                completion: @escaping (Error?) -> ())
    func cancel()
}
