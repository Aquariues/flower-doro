import SwiftUI

public struct FlowerDoroRootView: View {
    @StateObject private var timer = FocusTimerStore()

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    timerCard
                    settingsCard
                    garden
                }
                .padding()
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.windowBackgroundColorCompat))
            .navigationTitle("Flower-doro")
        }
    }

    private var timerCard: some View {
        VStack(spacing: 18) {
            Text(timer.phase.title)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(timer.remainingTimeText)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.6)

            ProgressView(value: timer.progress)
                .tint(timer.phase.tint)

            HStack(spacing: 12) {
                Button(timer.isRunning ? "Pause" : "Start") {
                    timer.toggleRunning()
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    timer.reset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session")
                .font(.headline)

            Stepper("Work: \(timer.workMinutes) min", value: $timer.workMinutes, in: 1...120)
            Stepper("Break: \(timer.breakMinutes) min", value: $timer.breakMinutes, in: 1...60)
        }
        .disabled(timer.isRunning)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var garden: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Garden")
                    .font(.headline)

                Spacer()

                Text("\(timer.flowers.count) flowers")
                    .foregroundStyle(.secondary)
            }

            if timer.flowers.isEmpty {
                Text("Finish a focus session to grow your first flower.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 24)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 64), spacing: 12)], spacing: 12) {
                    ForEach(timer.flowers) { flower in
                        FlowerTile(flower: flower)
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct FlowerTile: View {
    let flower: Flower

    var body: some View {
        VStack(spacing: 6) {
            Text("flower")
                .font(.system(size: 30))
                .accessibilityHidden(true)

            Text("\(flower.focusMinutes)m")
                .font(.caption)
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
        .frame(width: 64, height: 72)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .accessibilityLabel("Flower earned from \(flower.focusMinutes) minutes of focus")
    }
}

#if os(macOS)
private extension NSColor {
    static var windowBackgroundColorCompat: NSColor { .windowBackgroundColor }
}
#else
private extension UIColor {
    static var windowBackgroundColorCompat: UIColor { .systemGroupedBackground }
}
#endif

private extension FocusPhase {
    var title: String {
        switch self {
        case .work:
            "Focus"
        case .break:
            "Break"
        }
    }

    var tint: Color {
        switch self {
        case .work:
            .green
        case .break:
            .mint
        }
    }
}
