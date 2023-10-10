import AVFoundation

public enum ImageSequencerFactory {
    
    private struct FrameworkDependencies {
        let videoWriter: AssetWriter
        let videoWriterInput: AssetWriterInput
        let pixelBufferController: PixelBufferController
        let pixelBufferAdapter: AssetWriterInputPixelBufferAdaptor
    }
    
    public static func make(settings: RenderSettings) throws -> ImageSequencerController {
        let frameworkDependencies = try self.setupFrameworks(settings)
            
        return DefaultImageSequencerController(startRenderUseCase: StartRenderUseCase(videoWriterInput: frameworkDependencies.videoWriterInput,
                                                                                      assetWriter: frameworkDependencies.videoWriter),
                                               finishRenderUseCase: FinishRenderUseCase(videoWriterInput: frameworkDependencies.videoWriterInput,
                                                                                        assetWriter: frameworkDependencies.videoWriter),
                                               renderImagesUseCase: RenderImagesUseCase(videoWriterInput: frameworkDependencies.videoWriterInput,
                                                                                        pixelBufferAdaptor: frameworkDependencies.pixelBufferAdapter,
                                                                                        renderSettings: settings,
                                                                                        pixelBufferController: frameworkDependencies.pixelBufferController,
                                                                                        canvas: DefaultCanvas()),
                                               cancelRenderUseCase: CancelRenderUseCase(assetWriter: frameworkDependencies.videoWriter))
    }
    
    private static func setupFrameworks(_ settings: RenderSettings) throws -> FrameworkDependencies {
        let assetWriter = try AVAssetWriter(outputURL: settings.outputUrl, fileType: .mp4)
        let videoWriter = DefaultAssetWriter(assetWriter: assetWriter)
        
        let avOutputSettings = OutputSettings.from(settings)
        let avAssetWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video,
                                                outputSettings: avOutputSettings)
        
        let videoWriterInput = DefaultAssetWriterInput(videoWriterInput: avAssetWriterInput)
        assetWriter.add(avAssetWriterInput)

        let sourcePixelBufferAttributesDictionary = PixelBufferAttributes.from(settings)
        
        let avPixelBufferAdapter = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: avAssetWriterInput,
                                                                        sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        
        var pixelBuffer: CVPixelBuffer?
        
        let pixelBufferController = DefaultPixelBufferController(avPixelBufferAdapter,
                                                                  &pixelBuffer)
                
        let pixelBufferAdaptor = DefaultAssetWriterInputPixelBufferAdaptor(pixelBufferAdaptor: avPixelBufferAdapter)
        
        return FrameworkDependencies(videoWriter: videoWriter,
                                     videoWriterInput: videoWriterInput,
                                     pixelBufferController: pixelBufferController,
                                     pixelBufferAdapter: pixelBufferAdaptor)
    }
}
