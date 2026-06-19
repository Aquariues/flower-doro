import FlowerDoro
import SwiftUI

@main
struct FlowerDoroMacApp: App {
    var body: some Scene {
        WindowGroup {
            FlowerDoroRootView()
                .frame(minWidth: 260, idealWidth: 310, maxWidth: 440)
                .frame(minHeight: 160, idealHeight: 196, maxHeight: 560)
        }
        .windowResizability(.contentSize)
    }
}
