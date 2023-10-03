import SwiftUI

@main
struct ImageSequencerExampleAppApp: App {
    var body: some Scene {
        WindowGroup {
            create()
        }
    }
    
    func create() -> AnyView {
        let presenter = Presenter()
        let view = ContentView(presenter: presenter, viewModel: ViewModel())
        presenter.set(view)
        
        return AnyView(view)
    }
}
