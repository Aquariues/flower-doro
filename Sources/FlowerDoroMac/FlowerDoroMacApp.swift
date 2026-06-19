import FlowerDoro
import SwiftUI

@main
struct FlowerDoroMacApp: App {
    var body: some Scene {
        WindowGroup {
            FlowerDoroRootView()
                .frame(minWidth: 430, minHeight: 720)
        }
        .windowResizability(.contentSize)
    }
}
