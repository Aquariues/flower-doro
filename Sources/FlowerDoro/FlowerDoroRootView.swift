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
                    claimCard
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
                Text(timer.gardenTitle)
                    .font(.headline)

                Spacer()

                Text("\(timer.garden.flowers.count) flowers")
                    .foregroundStyle(.secondary)
            }

            if timer.garden.flowers.isEmpty {
                Text("Finish a focus session to grow your first flower.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 24)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 64), spacing: 12)], spacing: 12) {
                    ForEach(timer.garden.flowers) { flower in
                        FlowerTile(flower: flower)
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    @ViewBuilder
    private var claimCard: some View {
        if let pendingClaim = timer.pendingClaim {
            VStack(alignment: .leading, spacing: 14) {
                Text("Flower Ready")
                    .font(.headline)

                Text("You finished \(pendingClaim.focusMinutes) minutes of focus. Claim a random flower for your garden.")
                    .foregroundStyle(.secondary)

                Button("Claim Random Flower") {
                    timer.claimFlower()
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

private struct FlowerTile: View {
    let flower: Flower

    var body: some View {
        VStack(spacing: 6) {
            FlowerAssetImage(kind: flower.kind)
                .frame(width: 46, height: 46)

            Text(flower.kind.displayName)
                .font(.caption2)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text("\(flower.focusMinutes)m")
                .font(.caption)
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
        .frame(width: 76, height: 86)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .accessibilityLabel("\(flower.kind.displayName) earned from \(flower.focusMinutes) minutes of focus")
    }
}

private struct FlowerAssetImage: View {
    let kind: FlowerKind

    var body: some View {
        #if os(macOS)
        if let image = Self.image(kind: kind) {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
        } else {
            fallback
        }
        #else
        if let image = Self.image(kind: kind) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            fallback
        }
        #endif
    }

    private var fallback: some View {
        Image(systemName: kind.symbolName)
            .font(.system(size: 28, weight: .semibold))
            .foregroundStyle(kind.tint)
    }

    #if os(macOS)
    private static func image(kind: FlowerKind) -> NSImage? {
        guard let url = Bundle.module.url(
            forResource: kind.assetName,
            withExtension: "png",
            subdirectory: "Flowers"
        ) else {
            return nil
        }

        return NSImage(contentsOf: url)
    }
    #else
    private static func image(kind: FlowerKind) -> UIImage? {
        guard let url = Bundle.module.url(
            forResource: kind.assetName,
            withExtension: "png",
            subdirectory: "Flowers"
        ) else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }
    #endif
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

private extension FlowerKind {
    var tint: Color {
        switch self {
        case .daisy:
            .yellow
        case .rose:
            .red
        case .sunflower:
            .orange
        }
    }
}
