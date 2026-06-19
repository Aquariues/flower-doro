import FlowerDoro
import SwiftUI

@main
struct FlowerDoroMacApp: App {
    @StateObject private var timer = FocusTimerStore()

    var body: some Scene {
        WindowGroup {
            FlowerDoroRootView(timer: timer)
                .frame(minWidth: 188, idealWidth: 232, maxWidth: 380)
                .frame(minHeight: 62, idealHeight: 74, maxHeight: 420)
        }
        .windowResizability(.contentSize)

        MenuBarExtra {
            FlowerDoroDashboardView(timer: timer)
        } label: {
            Image(systemName: "camera.macro")
        }
        .menuBarExtraStyle(.window)
    }
}
