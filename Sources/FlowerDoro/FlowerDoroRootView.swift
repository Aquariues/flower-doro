import SwiftUI

public struct FlowerDoroRootView: View {
    @StateObject private var timer = FocusTimerStore()
    @State private var isGardenPresented = false
    @State private var isSettingsPresented = false

    public init() {}

    public var body: some View {
        compactTimer
            .padding(14)
            .frame(minWidth: 240, idealWidth: 290, maxWidth: 420)
            .frame(minHeight: 146, idealHeight: 174, maxHeight: 520)
            .background {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.16), radius: 24, y: 10)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(.white.opacity(0.28), lineWidth: 1)
            }
            .padding(10)
            .background(WindowTransparencyConfigurator())
    }

    private var compactTimer: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                phaseBadge

                Spacer(minLength: 8)

                Button {
                    isSettingsPresented.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                .buttonStyle(.plain)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 28, height: 28)
                .background(.thinMaterial)
                .clipShape(Circle())
                .popover(isPresented: $isSettingsPresented, arrowEdge: .bottom) {
                    settingsPanel
                }

                Button {
                    isGardenPresented.toggle()
                } label: {
                    flowerBadge
                }
                .buttonStyle(.plain)
                .popover(isPresented: $isGardenPresented, arrowEdge: .bottom) {
                    gardenPanel
                }
            }

            Text(timer.remainingTimeText)
                .font(.system(size: 54, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.55)
                .lineLimit(1)
                .frame(maxWidth: .infinity)

            ProgressView(value: timer.progress)
                .tint(timer.phase.tint)
                .controlSize(.small)

            HStack(spacing: 8) {
                Button(timer.isRunning ? "Pause" : "Start") {
                    timer.toggleRunning()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)

                Button {
                    timer.reset()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .help("Reset")
            }
        }
    }

    private var phaseBadge: some View {
        Text(timer.phase.title)
            .font(.caption.weight(.bold))
            .foregroundStyle(timer.phase.tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(timer.phase.tint.opacity(0.13), in: Capsule())
    }

    private var flowerBadge: some View {
        ZStack(alignment: .topTrailing) {
            Circle()
                .fill(.thinMaterial)
                .frame(width: 40, height: 40)

            Image(systemName: "camera.macro")
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.green)
                .frame(width: 40, height: 40)

            if !timer.garden.flowers.isEmpty {
                Text("\(timer.garden.flowers.count)")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .monospacedDigit()
                    .minimumScaleFactor(0.7)
                    .frame(minWidth: 16, minHeight: 16)
                    .padding(.horizontal, 3)
                    .background(.green, in: Capsule())
                    .offset(x: 4, y: -4)
            }
        }
        .accessibilityLabel("Open garden")
    }

    private var settingsPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session")
                .font(.headline)

            Stepper("Work: \(timer.workMinutes) min", value: $timer.workMinutes, in: 1...120)
            Stepper("Break: \(timer.breakMinutes) min", value: $timer.breakMinutes, in: 1...60)
        }
        .disabled(timer.isRunning)
        .padding()
        .frame(width: 260)
    }

    private var gardenPanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(timer.gardenTitle)
                    .font(.headline)

                Spacer()

                Text("\(timer.garden.flowers.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            if timer.garden.flowers.isEmpty {
                Text("Finish a focus session to grow your first flower.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 18)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 76), spacing: 12)], spacing: 12) {
                        ForEach(timer.garden.flowers) { flower in
                            FlowerTile(flower: flower)
                        }
                    }
                    .padding(.vertical, 2)
                }
                .frame(maxHeight: 300)
            }
        }
        .padding()
        .frame(width: 330)
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
private struct WindowTransparencyConfigurator: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            window.isOpaque = false
            window.backgroundColor = .clear
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
#else
private struct WindowTransparencyConfigurator: View {
    var body: some View {
        Color.clear
    }
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
