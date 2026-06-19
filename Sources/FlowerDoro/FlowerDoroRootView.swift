import SwiftUI

public struct FlowerDoroRootView: View {
    @StateObject private var timer = FocusTimerStore()
    @State private var isGardenPresented = false
    @State private var isSettingsPresented = false
    @State private var isHovering = false

    public init() {}

    public var body: some View {
        compactTimer
            .padding(timer.isRunning ? 8 : 14)
            .frame(minWidth: timer.isRunning ? 188 : 240, idealWidth: timer.isRunning ? 232 : 290, maxWidth: 380)
            .frame(minHeight: timer.isRunning ? 62 : 146, idealHeight: timer.isRunning ? 74 : 174, maxHeight: 460)
            .background {
                if timer.isRunning {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.clear)
                } else {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.16), radius: 24, y: 10)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(timer.phase.tint.opacity(timer.isRunning ? 0.95 : 0.38), lineWidth: timer.isRunning ? 2 : 1)
            }
            .padding(10)
            .background(WindowTransparencyConfigurator())
            .onHover { isHovering = $0 }
    }

    @ViewBuilder
    private var compactTimer: some View {
        if timer.isRunning {
            runningTimer
        } else {
            stoppedTimer
        }
    }

    private var runningTimer: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(timer.remainingTimeText)
                .font(.system(size: 35, weight: .bold, design: .rounded))
                .foregroundStyle(timer.phase.tint)
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)

            if timer.isRunningFocus {
                BloomingFlowerView(progress: timer.progress, tint: timer.phase.tint)
                    .frame(width: 30, height: 30)
                    .opacity(0.82)
                    .accessibilityLabel("Hoa dang no")
            }

            Button {
                isGardenPresented.toggle()
            } label: {
                compactFlowerBadge
            }
            .buttonStyle(.plain)
            .popover(isPresented: $isGardenPresented, arrowEdge: .bottom) {
                gardenPanel
            }
            .opacity(isHovering || !timer.garden.flowers.isEmpty ? 1 : 0.36)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            timer.pause()
        }
        .help("Click to pause")
    }

    private var stoppedTimer: some View {
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

    private var compactFlowerBadge: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "camera.macro")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(timer.phase.tint)
                .frame(width: 24, height: 24)

            if !timer.garden.flowers.isEmpty {
                Circle()
                    .fill(timer.phase.tint)
                    .frame(width: 8, height: 8)
                    .offset(x: 1, y: -1)
            }
        }
        .accessibilityLabel("Open garden")
    }

    private var settingsPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session")
                .font(.headline)

            HStack {
                Text("Work")
                Spacer()
                MinuteField(value: $timer.workMinutes, range: 1...120)
            }

            HStack {
                Text("Break")
                Spacer()
                MinuteField(value: $timer.breakMinutes, range: 1...60)
            }
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

private struct MinuteField: View {
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        HStack(spacing: 6) {
            TextField("", value: clampedValue, format: .number)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .monospacedDigit()
                .frame(width: 58)

            Text("min")
                .foregroundStyle(.secondary)
        }
    }

    private var clampedValue: Binding<Int> {
        Binding {
            value
        } set: { newValue in
            value = min(max(newValue, range.lowerBound), range.upperBound)
        }
    }
}

private struct BloomingFlowerView: View {
    let progress: Double
    let tint: Color

    private var bloom: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                Capsule()
                    .stroke(tint.opacity(0.72), lineWidth: 1.6)
                    .frame(width: 10 + bloom * 12, height: 20 + bloom * 24)
                    .offset(y: -(8 + bloom * 12))
                    .rotationEffect(.degrees(Double(index) * 45))
                    .scaleEffect(0.35 + bloom * 0.65)
            }

            Circle()
                .fill(tint.opacity(0.18))
                .frame(width: 8 + bloom * 8, height: 8 + bloom * 8)
                .overlay {
                    Circle()
                        .stroke(tint.opacity(0.9), lineWidth: 1.2)
                }
        }
        .animation(.easeInOut(duration: 0.35), value: bloom)
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
            window.styleMask = [.borderless, .resizable, .fullSizeContentView]
            window.hasShadow = false
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.standardWindowButton(.closeButton)?.isHidden = true
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.toolbarStyle = .unifiedCompact
            window.isMovableByWindowBackground = true
            window.level = .floating
            window.collectionBehavior.insert(.canJoinAllSpaces)
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
            Color(red: 0.18, green: 0.78, blue: 0.43)
        case .break:
            Color(red: 0.28, green: 0.72, blue: 0.98)
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
