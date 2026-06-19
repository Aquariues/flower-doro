import FlowerDoro
import SwiftUI

@main
struct FlowerDoroMacApp: App {
    var body: some Scene {
        WindowGroup {
            FlowerDoroRootView()
                .frame(minWidth: 176, idealWidth: 290, maxWidth: 380)
                .frame(minHeight: 74, idealHeight: 174, maxHeight: 420)
        }
        .windowResizability(.contentSize)
    }
}
