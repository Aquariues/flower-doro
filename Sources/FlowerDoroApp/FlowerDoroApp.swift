import FlowerDoro
import SwiftUI

@main
struct FlowerDoroApp: App {
    @StateObject private var timer = FocusTimerStore()

    init() {
        UserDefaults.standard.register(defaults: [
            "FlowerDoro.language": AppLanguage.vietnamese.rawValue
        ])
    }

    var body: some Scene {
        WindowGroup {
            FlowerDoroRootView(timer: timer)
                .frame(minWidth: 94, idealWidth: 128, maxWidth: 190)
                .frame(minHeight: 31, idealHeight: 42, maxHeight: 65)
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
