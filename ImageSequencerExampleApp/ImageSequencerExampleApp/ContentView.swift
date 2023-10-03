import SwiftUI
import AVKit

protocol Viewable {
    func didUpdateRenderingState(state: RenderingState)
}

struct ContentView: View {
    
    @ObservedObject private var viewModel: ViewModel
    private let presenter: Presenter
    
    init(presenter: Presenter,
         viewModel: ViewModel) {
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("Render settings") {
                        HStack {
                            Text("No. of Frames")
                            Spacer()
                            TextField("Frames", value: $viewModel.numberOfFrames, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("FPS")
                            Spacer()
                            TextField("Frames per second", value: $viewModel.fps, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Bitrate")
                            Spacer()
                            TextField("Bitrate", value: $viewModel.bitrate, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Height")
                            Spacer()
                            TextField("Height", value: $viewModel.height, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Width")
                            Spacer()
                            TextField("Width", value: $viewModel.width, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    Section {
                        Button(action: {
                            presenter.didTapMakeImages(fps: viewModel.fps,
                                                       bitrate: viewModel.bitrate,
                                                       height: viewModel.height,
                                                       width: viewModel.width,
                                                       numberOfFrames: viewModel.numberOfFrames)
                        }, label: {
                            HStack(spacing: 10) {
                                switch viewModel.renderingState {
                                case .notRendering:
                                    Text("Render")
                                        .bold()
                                case .creatingFrames(let currentFrame, let total):
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                    Text("Creating frames (\(currentFrame)/\(total))")
                                        .bold()
                                case .rendering(let percent):
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                    Text("Rendering \(Int(percent))%")
                                        .bold()
                                case .finished:
                                    Text("Render")
                                        .bold()
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        })
                        .disabled(viewModel.renderingState == .rendering(percent: 100) ||
                                  viewModel.renderingState == .creatingFrames(currentFrame: 1, total: 0))
                        .buttonStyle(.borderedProminent)
                    }
                    .listRowInsets(.init())
                    
                    if case .finished(let videoUrl) = viewModel.renderingState {
                        Section("Video Output") {
                            let player = AVPlayer(url: videoUrl)
                            VideoPlayer(player: player)
                                .frame(height: 400)
                                .onAppear { player.play() }
                        }
                    }
                }
            }
            .navigationTitle("Image Sequencer")
        }
    }
}

extension ContentView: Viewable {
    func didUpdateRenderingState(state: RenderingState) {
        viewModel.renderingState = state
    }
}

#Preview {
    ContentView(presenter: Presenter(), viewModel: ViewModel())
}
