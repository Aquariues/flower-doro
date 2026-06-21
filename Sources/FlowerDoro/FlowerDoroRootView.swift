import SwiftUI

#if os(macOS)
import AppKit
#endif

public struct FlowerDoroRootView: View {
    @StateObject private var timer = FocusTimerStore()
    @State private var isGardenPresented = false
    @State private var isSettingsPresented = false
    @State private var isHovering = false
    @AppStorage("FlowerDoro.language") private var languageCode = AppLanguage.vietnamese.rawValue

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
                .accessibilityLabel(copy.flowerGrowingAccessibility)
            }
        }
    }

    private var phaseBadge: some View {
        Text(copy.phaseTitle(timer.phase))
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
        .accessibilityLabel(copy.openGardenAccessibility)
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
        .accessibilityLabel(copy.openGardenAccessibility)
    }
    private var settingsPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(copy.session)
                .font(.headline)

            HStack {
                Text(copy.work)
                Spacer()
                MinuteField(value: $timer.workMinutes, range: 1...120, copy: copy)
            }

            HStack {
                Text(copy.breakLabel)
                Spacer()
                MinuteField(value: $timer.breakMinutes, range: 1...60, copy: copy)
            }
        }
        .disabled(timer.isRunning)
        .padding()
        .frame(width: 260)
    }

    private var gardenPanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(copy.gardenTitle(userName: timer.garden.userName))
                    .font(.headline)

                Spacer()

                Text("\(timer.garden.flowers.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            if timer.garden.flowers.isEmpty && timer.activeFlowerKind == nil {
                Text(copy.finishFirstFlower)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 18)
            } else {
                ScrollView {
                    GardenBedView(flowers: timer.garden.flowers, activeKind: timer.activeFlowerKind, activeStage: timer.focusGrowthStage, activeProgress: timer.focusGrowthProgress, copy: copy)
                        .padding(.vertical, 2)
                }
                .frame(maxHeight: 300)
            }
        }
        .padding()
        .frame(width: 330)
    }

    private var language: AppLanguage {
        AppLanguage(rawValue: languageCode) ?? .vietnamese
    }

    private var copy: AppCopy {
        AppCopy(language: language)
    }
}

public struct FlowerDoroDashboardView: View {
    @ObservedObject private var timer: FocusTimerStore
    @StateObject private var updateChecker = ReleaseUpdateChecker()
    @State private var selectedMainTab: DashboardMainTab = .session
    @State private var selectedDashboardTab: DashboardTab = .garden
    @State private var flowerBookSpreadIndex = 0
    @AppStorage("FlowerDoro.autoCheckUpdates") private var autoCheckUpdates = true
    @AppStorage("FlowerDoro.language") private var languageCode = AppLanguage.vietnamese.rawValue
    @Environment(\.openURL) private var openURL

    public init(timer: FocusTimerStore) {
        self.timer = timer
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                dashboardHeader

                Picker(copy.app, selection: $selectedMainTab) {
                    ForEach(DashboardMainTab.allCases) { tab in
                        Text(tab.title(copy: copy)).tag(tab)
                    }
                }
                .pickerStyle(.segmented)

                switch selectedMainTab {
                case .session:
                    sessionSection
                case .garden:
                    gardenScreen
                case .appSettings:
                    appSection
                }
            }
            .padding()
        }
        .frame(width: 430, height: 700)
        .background(.regularMaterial)
        .task {
            if autoCheckUpdates {
                await updateChecker.checkForUpdates()
            }
        }
        .onChange(of: autoCheckUpdates) { _, isEnabled in
            guard isEnabled else { return }
            Task {
                await updateChecker.checkForUpdates()
            }
        }
    }

    private var dashboardHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Flower-doro")
                    .font(.title2.weight(.bold))

                Text(copy.phaseTitle(timer.phase))
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(timer.phase.tint)
            }

            Spacer()

            Text(timer.remainingTimeText)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(timer.phase.tint)
                .monospacedDigit()
        }
    }

    private var sessionSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            ProgressView(value: timer.progress)
                .tint(timer.phase.tint)

            HStack(spacing: 10) {
                Button(timer.isRunning ? copy.pause : copy.start) {
                    timer.toggleRunning()
                }
                .buttonStyle(.borderedProminent)

                Button(copy.reset) {
                    timer.reset()
                }
                .buttonStyle(.bordered)
            }

            Picker(copy.clock, selection: $timer.clockStyle) {
                ForEach(ClockStyle.allCases) { style in
                    Text(copy.clockStyleName(style)).tag(style)
                }
            }
            .pickerStyle(.segmented)

            statsGrid

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Text(copy.session)
                    .font(.headline)

                HStack {
                    Text(copy.work)
                    Spacer()
                    MinuteField(value: $timer.workMinutes, range: 1...120, copy: copy)
                }

                HStack {
                    Text(copy.breakLabel)
                    Spacer()
                    MinuteField(value: $timer.breakMinutes, range: 1...60, copy: copy)
                }
            }
            .disabled(timer.isRunning)
        }
    }

    private var statsGrid: some View {
        let stats = timer.stats

        return HStack(spacing: 8) {
            FocusStatCard(title: copy.today, value: stats.today)
            FocusStatCard(title: copy.week, value: stats.thisWeek)
            FocusStatCard(title: copy.month, value: stats.thisMonth)
        }
    }

    private var gardenSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(copy.gardenTitle(userName: timer.garden.userName))
                    .font(.headline)

                Spacer()

                Text("\(timer.garden.flowers.count) \(copy.flowers)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            if timer.garden.flowers.isEmpty && timer.activeFlowerKind == nil {
                Text(copy.finishFirstFlower)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 14)
            } else {
                GardenBedView(
                    flowers: timer.garden.flowers,
                    activeKind: timer.activeFlowerKind,
                    activeStage: timer.focusGrowthStage,
                    activeProgress: timer.focusGrowthProgress,
                    copy: copy
                )
            }
        }
    }

    private var collectionTabs: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker(copy.collection, selection: $selectedDashboardTab) {
                ForEach(DashboardTab.allCases) { tab in
                    Text(tab.title(copy: copy)).tag(tab)
                }
            }
            .pickerStyle(.segmented)

            switch selectedDashboardTab {
            case .garden:
                gardenSection
            case .flowerBook:
                flowerBookSection
            }
        }
    }

    private var gardenScreen: some View {
        collectionTabs
    }

    private var flowerBookSection: some View {
        let unlockedKinds = Set(timer.garden.flowers.map(\.kind))

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(copy.flowerBook)
                    .font(.headline)

                Spacer()

                Text("\(unlockedKinds.count)/\(FlowerKind.allCases.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            FlowerBookSpreadView(
                flowers: timer.garden.flowers,
                unlockedKinds: unlockedKinds,
                spreadIndex: $flowerBookSpreadIndex,
                copy: copy
            )
        }
    }

    private var appSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(copy.appSettings)
                .font(.headline)

            Picker(copy.languageLabel, selection: languageBinding) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.displayName).tag(language.rawValue)
                }
            }
            .pickerStyle(.menu)

            Toggle(copy.autoCheckUpdates, isOn: $autoCheckUpdates)

            updateStatusView

            HStack(spacing: 10) {
                Button {
                    Task {
                        await updateChecker.checkForUpdates()
                    }
                } label: {
                    Label(copy.checkUpdates, systemImage: "arrow.triangle.2.circlepath")
                }
                .disabled(updateChecker.status == .checking)

                if let releaseURL = latestReleaseURL {
                    Button {
                        openURL(releaseURL)
                    } label: {
                        Label(copy.openRelease, systemImage: "arrow.down.circle")
                    }
                }

                Spacer()

                #if os(macOS)
                Button(role: .destructive) {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Label(copy.quit, systemImage: "power")
                }
                #endif
            }
            .buttonStyle(.bordered)
        }
    }

    @ViewBuilder
    private var updateStatusView: some View {
        switch updateChecker.status {
        case .idle:
            Text(copy.updatesUseGitHub)
                .font(.caption)
                .foregroundStyle(.secondary)
        case .checking:
            HStack(spacing: 8) {
                ProgressView()
                    .controlSize(.small)
                Text(copy.checkingReleases)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        case .available(let release):
            Text(copy.latestRelease(release.name))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.green)
                .lineLimit(1)
        case .unavailable:
            Text(copy.upToDate)
                .font(.caption)
                .foregroundStyle(.secondary)
        case .failed(let message):
            Text(copy.releaseFailureMessage(message))
                .font(.caption)
                .foregroundStyle(.red)
        }
    }

    private var latestReleaseURL: URL? {
        if case .available(let release) = updateChecker.status {
            release.htmlURL
        } else {
            URL(string: "https://github.com/Aquariues/flower-doro/releases/latest")
        }
    }

    private var language: AppLanguage {
        AppLanguage(rawValue: languageCode) ?? .vietnamese
    }

    private var copy: AppCopy {
        AppCopy(language: language)
    }

    private var languageBinding: Binding<String> {
        Binding {
            languageCode
        } set: { newValue in
            languageCode = AppLanguage(rawValue: newValue)?.rawValue ?? AppLanguage.vietnamese.rawValue
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

private enum DashboardMainTab: String, CaseIterable, Identifiable {
    case session
    case garden
    case appSettings

    var id: String { rawValue }

    func title(copy: AppCopy) -> String {
        switch self {
        case .session:
            copy.session
        case .garden:
            copy.garden
        case .appSettings:
            copy.appSettings
        }
    }
}

private enum DashboardTab: String, CaseIterable, Identifiable {
    case garden
    case flowerBook

    var id: String { rawValue }

    func title(copy: AppCopy) -> String {
        switch self {
        case .garden:
            copy.garden
        case .flowerBook:
            copy.flowerBook
        }
    }
}

private struct FlowerBookSpreadView: View {
    let flowers: [Flower]
    let unlockedKinds: Set<FlowerKind>
    @Binding var spreadIndex: Int
    let copy: AppCopy

    private var spreadCount: Int {
        Int(ceil(Double(FlowerKind.allCases.count) / 2))
    }

    private var pageKinds: [FlowerKind] {
        let start = spreadIndex * 2
        return FlowerKind.allCases.enumerated()
            .filter { start..<(start + 2) ~= $0.offset }
            .map(\.element)
    }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(red: 0.02, green: 0.24, blue: 0.23))
                    .shadow(color: .black.opacity(0.20), radius: 8, y: 4)

                HStack(spacing: 0) {
                    ForEach(pageKinds, id: \.self) { kind in
                        FlowerBookPageView(
                            kind: kind,
                            isUnlocked: unlockedKinds.contains(kind),
                            count: flowers.filter { $0.kind == kind }.count,
                            copy: copy
                        )
                    }

                    if pageKinds.count == 1 {
                        BlankBookPageView()
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.black.opacity(0.10), .white.opacity(0.30), .black.opacity(0.08)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 14)
                    .blur(radius: 1.5)
            }
            .frame(height: 300)

            HStack(spacing: 12) {
                Button {
                    spreadIndex = max(spreadIndex - 1, 0)
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.bordered)
                .disabled(spreadIndex == 0)
                .help(copy.previousPage)

                Spacer()

                Text(copy.page(spreadIndex + 1, spreadCount))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()

                Spacer()

                Button {
                    spreadIndex = min(spreadIndex + 1, spreadCount - 1)
                } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.bordered)
                .disabled(spreadIndex >= spreadCount - 1)
                .help(copy.nextPage)
            }
        }
        .onAppear {
            spreadIndex = min(spreadIndex, max(spreadCount - 1, 0))
        }
    }
}

private struct FlowerBookPageView: View {
    let kind: FlowerKind
    let isUnlocked: Bool
    let count: Int
    let copy: AppCopy

    var body: some View {
        let info = copy.flowerInfo(kind)

        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(isUnlocked ? info.name : "????")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(isUnlocked ? kind.tint : Color(red: 0.18, green: 0.18, blue: 0.18))
                        .shadow(color: .black.opacity(isUnlocked ? 0.24 : 0.12), radius: 0.6, x: 0, y: 0.8)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)

                    Text(isUnlocked ? copy.collectedCount(count) : copy.unknownFlower)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(isUnlocked ? kind.tint : Color(red: 0.34, green: 0.34, blue: 0.34))
                        .shadow(color: .black.opacity(isUnlocked ? 0.20 : 0.10), radius: 0.5, x: 0, y: 0.7)
                        .monospacedDigit()
                }

                Spacer()

                Image(systemName: isUnlocked ? "bookmark.fill" : "lock.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(isUnlocked ? kind.tint : Color(red: 0.42, green: 0.42, blue: 0.42))
            }

            ZStack {
                Circle()
                    .fill(isUnlocked ? kind.tint.opacity(0.12) : Color.secondary.opacity(0.10))
                    .frame(width: 72, height: 72)

                if isUnlocked {
                    FlowerAssetImage(kind: kind)
                        .frame(width: 70, height: 70)
                } else {
                    Text("????")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color(red: 0.34, green: 0.34, blue: 0.34))
                        .shadow(color: .black.opacity(0.12), radius: 0.6, x: 0, y: 0.8)
                }
            }
            .frame(maxWidth: .infinity)

            Text(isUnlocked ? info.shortDescription : copy.lockedFlowerPrompt)
                .font(.caption)
                .foregroundStyle(Color(red: 0.12, green: 0.12, blue: 0.12))
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            VStack(alignment: .leading, spacing: 5) {
                ForEach(displayFacts, id: \.self) { fact in
                    HStack(alignment: .top, spacing: 5) {
                        Circle()
                            .fill(isUnlocked ? kind.tint : Color.secondary.opacity(0.55))
                            .frame(width: 4, height: 4)
                            .padding(.top, 5)

                        Text(fact)
                            .font(.caption2)
                            .foregroundStyle(isUnlocked ? Color(red: 0.10, green: 0.10, blue: 0.10) : Color(red: 0.34, green: 0.34, blue: 0.34))
                            .lineLimit(2)
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(pageBackground)
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(.black.opacity(0.05))
                .frame(width: 1)
        }
        .accessibilityLabel(copy.flowerBookPageAccessibility(info.name, unlocked: isUnlocked))
    }

    private var pageBackground: some ShapeStyle {
        LinearGradient(
            colors: [
                .white,
                Color(red: 0.97, green: 0.97, blue: 0.94)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var displayFacts: [String] {
        if isUnlocked {
            Array(copy.flowerInfo(kind).facts.prefix(2))
        } else {
            ["????", "????"]
        }
    }
}

private struct BlankBookPageView: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        .white,
                        Color(red: 0.97, green: 0.97, blue: 0.94)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct MinuteField: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    let copy: AppCopy

    var body: some View {
        HStack(spacing: 6) {
            TextField("", value: clampedValue, format: .number)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .monospacedDigit()
                .frame(width: 58)

            Text(copy.minuteShort)
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
    let copy: AppCopy

    private var groupedFlowers: [(kind: FlowerKind, count: Int, minutes: Int)] {
        FlowerKind.allCases.compactMap { kind in
            let matching = flowers.filter { $0.kind == kind }
            guard !matching.isEmpty else { return nil }
            return (
                kind: kind,
                count: matching.count,
                minutes: matching.reduce(0) { $0 + $1.focusMinutes }
            )
        }
    }

    private var recentFlowers: [Flower] {
        Array(flowers.prefix(8))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.12, green: 0.30, blue: 0.18).opacity(0.88),
                                Color(red: 0.18, green: 0.45, blue: 0.25).opacity(0.46)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .overlay(alignment: .bottom) {
                        UnevenRoundedRectangle(
                            cornerRadii: RectangleCornerRadii(
                                topLeading: 0,
                                bottomLeading: 8,
                                bottomTrailing: 8,
                                topTrailing: 0
                            ),
                            style: .continuous
                        )
                        .fill(Color(red: 0.39, green: 0.25, blue: 0.13).opacity(0.78))
                        .frame(height: 52)
                    }
                    .overlay(alignment: .topLeading) {
                        Text("\(flowers.count) \(copy.blooms)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white.opacity(0.86))
                            .monospacedDigit()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(.black.opacity(0.18), in: Capsule())
                            .padding(10)
                    }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: 10) {
                        if let activeKind {
                            GrowingPlotView(kind: activeKind, stage: activeStage, progress: activeProgress, copy: copy)
                        }

                        ForEach(groupedFlowers, id: \.kind) { plot in
                            GardenPlotView(kind: plot.kind, count: plot.count, minutes: plot.minutes, copy: copy)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                    .padding(.top, 40)
                }
            }
            .frame(minHeight: 170)

            if !recentFlowers.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(copy.recentBlooms)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(recentFlowers) { flower in
                                RecentBloomPill(flower: flower, copy: copy)
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct GardenPlotView: View {
    let kind: FlowerKind
    let count: Int
    let minutes: Int
    let copy: AppCopy

    private var flowerSlots: Int {
        min(max(count, 1), 5)
    }

    private var opacity: Double {
        count == 0 ? 0.22 : 1
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                Capsule()
                    .fill(Color.black.opacity(0.14))
                    .frame(height: 18)
                    .offset(y: 3)

                HStack(alignment: .bottom, spacing: -8) {
                    ForEach(0..<flowerSlots, id: \.self) { index in
                        FlowerAssetImage(kind: kind)
                            .frame(width: 28, height: 34)
                            .scaleEffect(index == 2 ? 1.04 : 0.88)
                            .offset(y: index.isMultiple(of: 2) ? 0 : 4)
                    }
                }
                .opacity(opacity)
            }
            .frame(height: 48)

            Text(copy.flowerInfo(kind).name)
                .font(.caption2.weight(.bold))
                .lineLimit(1)

            HStack(spacing: 3) {
                Text("\(count)")
                    .font(.caption.weight(.bold))
                    .monospacedDigit()

                Text("x")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Text(copy.focusMinutes(minutes))
                .font(.caption2)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .frame(width: 82)
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
        .background(.white.opacity(count == 0 ? 0.08 : 0.18), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(kind.tint.opacity(count == 0 ? 0.12 : 0.44), lineWidth: 1)
        }
        .foregroundStyle(count == 0 ? .secondary : .primary)
    }
}

private struct GrowingPlotView: View {
    let kind: FlowerKind
    let stage: FlowerGrowthStage
    let progress: Double
    let copy: AppCopy

    var body: some View {
        VStack(spacing: 6) {
            GrowingFlowerView(kind: kind, stage: stage, progress: progress, tint: .green)
                .frame(width: 42, height: 54)

            Text(copy.growing)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.green)

            ProgressView(value: progress)
                .tint(.green)
                .frame(width: 48)
        }
        .frame(width: 76)
        .padding(.vertical, 8)
        .background(.green.opacity(0.16), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.green.opacity(0.54), lineWidth: 1)
        }
    }
}

private struct RecentBloomPill: View {
    let flower: Flower
    let copy: AppCopy

    var body: some View {
        HStack(spacing: 6) {
            FlowerAssetImage(kind: flower.kind)
                .frame(width: 22, height: 22)

            VStack(alignment: .leading, spacing: 1) {
                Text(copy.flowerInfo(flower.kind).name)
                    .font(.caption2.weight(.bold))
                    .lineLimit(1)

                Text(Self.dateFormatter.string(from: flower.earnedAt))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .accessibilityLabel(copy.flowerRewardAccessibility(copy.flowerInfo(flower.kind).name, minutes: flower.focusMinutes))
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
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
        guard let url = imageURL(kind: kind) else {
            return nil
        }

        return NSImage(contentsOf: url)
    }
    #else
    private static func image(kind: FlowerKind) -> UIImage? {
        guard let url = imageURL(kind: kind) else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }
    #endif

    private static func imageURL(kind: FlowerKind) -> URL? {
        Bundle.module.url(forResource: kind.assetName, withExtension: "png")
            ?? Bundle.module.url(forResource: kind.assetName, withExtension: "png", subdirectory: "Flowers")
    }
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
        case .tulip:
            .pink
        case .lotus:
            Color(red: 1, green: 0.63, blue: 0.76)
        case .lavender:
            .purple
        case .orchid:
            Color(red: 0.66, green: 0.35, blue: 0.95)
        case .cherryBlossom:
            Color(red: 1, green: 0.70, blue: 0.78)
        case .poppy:
            Color(red: 0.95, green: 0.22, blue: 0.12)
        case .hydrangea:
            Color(red: 0.36, green: 0.55, blue: 1)
        }
    }
}
