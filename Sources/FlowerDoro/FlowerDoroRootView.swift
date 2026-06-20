import SwiftUI

public struct FlowerDoroRootView: View {
    @StateObject private var timer = FocusTimerStore()
    @State private var isGardenPresented = false
    @State private var isSettingsPresented = false
    @State private var isHovering = false

    @MainActor
    public init() {
        _timer = StateObject(wrappedValue: FocusTimerStore())
    }

    @MainActor
    public init(timer: FocusTimerStore) {
        _timer = StateObject(wrappedValue: timer)
    }

    public var body: some View {
        Group {
            if timer.isRunning {
                compactTimer
                    .padding(8)
                    .frame(minWidth: 188, idealWidth: 232, maxWidth: 380)
                    .frame(minHeight: 62, idealHeight: 74, maxHeight: 130)
                    .background {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(.clear)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .strokeBorder(timer.phase.tint.opacity(0.95), lineWidth: 2)
                    }
                    .padding(10)
            } else {
                Color.clear
                    .frame(width: 1, height: 1)
            }
        }
        .background(WindowTransparencyConfigurator())
        .onHover { isHovering = $0 }
    }

    @ViewBuilder
    private var compactTimer: some View {
        runningTimer
    }

    private var runningTimer: some View {
        HStack(alignment: .center, spacing: 8) {
            clockFace
        }
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var clockFace: some View {
        switch timer.clockStyle {
        case .outline:
            outlineClock
        case .petal:
            petalClock
        case .gardenBed:
            gardenBedClock
        }
    }

    private var outlineClock: some View {
        Text(timer.remainingTimeText)
            .font(.system(size: 35, weight: .bold, design: .rounded))
            .foregroundStyle(timer.phase.tint)
            .monospacedDigit()
            .minimumScaleFactor(0.7)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
    }

    private var petalClock: some View {
        HStack(spacing: 7) {
            PetalProgressMark(progress: timer.phase == .work ? timer.progress : 1 - timer.progress, tint: timer.phase.tint)
                .frame(width: 26, height: 26)

            outlineClock
        }
    }

    private var gardenBedClock: some View {
        HStack(spacing: 8) {
            outlineClock

            if timer.phase == .work {
                GrowingFlowerView(
                    kind: timer.activeFlowerKind ?? timer.latestFlower?.kind ?? .daisy,
                    stage: timer.focusGrowthStage,
                    progress: timer.focusGrowthProgress,
                    tint: timer.phase.tint
                )
                .frame(width: 36, height: 34)
                .accessibilityLabel("Flower growing")
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

            if timer.garden.flowers.isEmpty && timer.activeFlowerKind == nil {
                Text("Finish a focus session to grow your first flower.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 18)
            } else {
                ScrollView {
                    GardenBedView(flowers: timer.garden.flowers, activeKind: timer.activeFlowerKind, activeStage: timer.focusGrowthStage, activeProgress: timer.focusGrowthProgress)
                        .padding(.vertical, 2)
                }
                .frame(maxHeight: 300)
            }
        }
        .padding()
        .frame(width: 330)
    }
}

public struct FlowerDoroDashboardView: View {
    @ObservedObject private var timer: FocusTimerStore

    public init(timer: FocusTimerStore) {
        self.timer = timer
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Flower-doro")
                            .font(.title2.weight(.bold))

                        Text(timer.phase.title)
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(timer.phase.tint)
                    }

                    Spacer()

                    Text(timer.remainingTimeText)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(timer.phase.tint)
                        .monospacedDigit()
                }

                ProgressView(value: timer.progress)
                    .tint(timer.phase.tint)

                HStack(spacing: 10) {
                    Button(timer.isRunning ? "Pause" : "Start") {
                        timer.toggleRunning()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset") {
                        timer.reset()
                    }
                    .buttonStyle(.bordered)
                }

                Picker("Clock", selection: $timer.clockStyle) {
                    ForEach(ClockStyle.allCases) { style in
                        Text(style.displayName).tag(style)
                    }
                }
                .pickerStyle(.segmented)

                Divider()

                statsGrid

                Divider()

                VStack(alignment: .leading, spacing: 12) {
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

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(timer.gardenTitle)
                            .font(.headline)

                        Spacer()

                        Text("\(timer.garden.flowers.count) flowers")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }

                    if timer.garden.flowers.isEmpty && timer.activeFlowerKind == nil {
                        Text("Finish a focus session to grow your first flower.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 14)
                    } else {
                        GardenBedView(flowers: timer.garden.flowers, activeKind: timer.activeFlowerKind, activeStage: timer.focusGrowthStage, activeProgress: timer.focusGrowthProgress)
                    }
                }
            }
            .padding()
        }
        .frame(width: 360, height: 500)
        .background(.regularMaterial)
    }

    private var statsGrid: some View {
        let stats = timer.stats

        return HStack(spacing: 8) {
            FocusStatCard(title: "Today", value: stats.today)
            FocusStatCard(title: "Week", value: stats.thisWeek)
            FocusStatCard(title: "Month", value: stats.thisMonth)
        }
    }
}

private struct FocusStatCard: View {
    let title: String
    let value: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .monospacedDigit()

            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.green.opacity(0.10), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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

private struct PetalProgressMark: View {
    let progress: Double
    let tint: Color

    private var filledPetals: Int {
        Int((min(max(progress, 0), 1) * 8).rounded(.up))
    }

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                Capsule()
                    .fill(index < filledPetals ? tint : tint.opacity(0.14))
                    .frame(width: 5, height: 10)
                    .offset(y: -7)
                    .rotationEffect(.degrees(Double(index) * 45))
            }

            Circle()
                .fill(tint.opacity(0.2))
                .frame(width: 7, height: 7)
        }
        .animation(.easeInOut(duration: 0.2), value: filledPetals)
    }
}

private struct GrowingFlowerView: View {
    let kind: FlowerKind
    let stage: FlowerGrowthStage
    let progress: Double
    let tint: Color

    private var bloom: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(Color.brown.opacity(0.35))
                .frame(width: 30, height: 6)
                .offset(y: 1)

            switch stage {
            case .seed:
                SeedView(tint: tint)
                    .transition(.scale.combined(with: .opacity))
            case .sprout:
                SproutView(tint: tint)
                    .transition(.scale.combined(with: .opacity))
            case .bud:
                BudView(kind: kind, tint: tint)
                    .transition(.scale.combined(with: .opacity))
            case .bloom:
                FlowerAssetImage(kind: kind)
                    .frame(width: 32, height: 32)
                    .scaleEffect(0.75 + bloom * 0.25)
                    .offset(y: -2)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: stage)
        .animation(.easeInOut(duration: 0.35), value: bloom)
    }
}

private struct SeedView: View {
    let tint: Color

    var body: some View {
        Circle()
            .fill(Color.brown.opacity(0.62))
            .frame(width: 10, height: 10)
            .overlay {
                Circle()
                    .stroke(tint.opacity(0.45), lineWidth: 1)
            }
            .offset(y: -4)
    }
}

private struct SproutView: View {
    let tint: Color

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(tint.opacity(0.62))
                .frame(width: 4, height: 19)

            HStack(spacing: 2) {
                Capsule()
                    .fill(tint.opacity(0.7))
                    .frame(width: 10, height: 6)
                    .rotationEffect(.degrees(-28))

                Capsule()
                    .fill(tint.opacity(0.7))
                    .frame(width: 10, height: 6)
                    .rotationEffect(.degrees(28))
            }
            .offset(y: -9)
        }
        .offset(y: -4)
    }
}

private struct BudView: View {
    let kind: FlowerKind
    let tint: Color

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(tint.opacity(0.52))
                .frame(width: 4, height: 24)

            Circle()
                .fill(kind.tint.opacity(0.74))
                .frame(width: 15, height: 15)
                .overlay {
                    Circle()
                        .stroke(tint.opacity(0.65), lineWidth: 1)
                }
                .offset(y: -20)
        }
    }
}

private struct GardenBedView: View {
    let flowers: [Flower]
    let activeKind: FlowerKind?
    let activeStage: FlowerGrowthStage
    let activeProgress: Double

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.brown.opacity(0.26), Color.green.opacity(0.10)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .overlay(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.brown.opacity(0.36))
                            .frame(height: 38)
                    }

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 74), spacing: 10)], spacing: 12) {
                    if let activeKind {
                        GardenPlantView(
                            label: "Growing",
                            kind: activeKind,
                            stage: activeStage,
                            progress: activeProgress,
                            isActive: true
                        )
                    }

                    ForEach(flowers) { flower in
                        GardenPlantView(label: flower.kind.displayName, kind: flower.kind, stage: .bloom, progress: 1, isActive: false)
                    }
                }
                .padding(12)
            }
            .frame(minHeight: 168)
        }
    }
}

private struct GardenPlantView: View {
    let label: String
    let kind: FlowerKind
    let stage: FlowerGrowthStage
    let progress: Double
    let isActive: Bool

    var body: some View {
        VStack(spacing: 4) {
            GrowingFlowerView(kind: kind, stage: stage, progress: progress, tint: .green)
                .frame(width: 54, height: 62)

            Text(label)
                .font(.caption2.weight(isActive ? .bold : .medium))
                .foregroundStyle(isActive ? .green : .secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(width: 74, height: 90)
        .background(isActive ? Color.green.opacity(0.12) : Color.white.opacity(0.18), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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
