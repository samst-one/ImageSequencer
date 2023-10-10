import Foundation

public protocol ImageSequencerController {
    
    /**
    Starts the processes of the Image Sequencer up, ready to render. Should be called before doing any rendering.
     */
    func start()
    
    
    /**
     Renders a selection of images. `start()` must have been called before calling this function.

     - Parameters:
        - images: The collection of images you wish to render in URL format.
        - didAddFrame: A closure that returns a double representing the percentage of rendering completed.
        - completion: A closure thats called when all the images have been rendered out.
     */
    func render(images: [URL],
                didAddFrame: @escaping (Double) -> (),
                completion: @escaping (Error?) -> ())
    
    
    /**
    Should be called once the rendering has finished to produce the finalised video.
     - Parameters:
        - completion: A closure to that is called with the output URL of the video when ImageSequencer has finished rendering the video.
     */
    func finish(completion: @escaping (URL) -> ())

    
    
    /**
    To be called mid way through a render should a user wish to cancel the rendering.
     */
    func cancel()
}
