import FlowerDoro
import SwiftUI

@main
struct FlowerDoroMacApp: App {
    var body: some Scene {
        WindowGroup {
            FlowerDoroRootView()
                .frame(minWidth: 188, idealWidth: 232, maxWidth: 380)
                .frame(minHeight: 62, idealHeight: 74, maxHeight: 420)
        }
        .windowResizability(.contentSize)
    }
}
