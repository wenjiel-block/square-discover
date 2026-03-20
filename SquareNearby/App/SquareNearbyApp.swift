import SwiftUI

@main
struct SquareNearbyApp: App {
    @State private var appState = AppState()

    private let serviceContainer: ServiceContainer = {
        #if DEBUG
        return ServiceContainer(useMocks: true)
        #else
        return ServiceContainer(useMocks: false)
        #endif
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(serviceContainer)
        }
    }
}
