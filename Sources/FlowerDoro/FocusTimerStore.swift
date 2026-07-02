import Foundation

@MainActor
public final class FocusTimerStore: ObservableObject {
    public static let minimumFlowerRewardMinutes = 30

    @Published public var workMinutes: Int {
        didSet { applySettingsChangeIfIdle() }
    }

    @Published public var breakMinutes: Int {
        didSet { applySettingsChangeIfIdle() }
    }

    @Published public private(set) var phase: FocusPhase
    @Published public private(set) var remainingSeconds: Int
    @Published public private(set) var isRunning: Bool
    @Published public private(set) var garden: UserGarden
    @Published public private(set) var latestFlower: Flower?
    @Published public var clockStyle: ClockStyle {
        didSet { saveHistory() }
    }
    @Published public private(set) var activeFlowerKind: FlowerKind?

    private var totalSeconds: Int
    private var ticker: Timer?
    private let historyStore: FocusHistoryPersisting

    public init(
        workMinutes: Int? = nil,
        breakMinutes: Int? = nil,
        garden: UserGarden? = nil,
        historyStore: FocusHistoryPersisting = FocusHistoryStore()
    ) {
        let history = historyStore.load()
        let shouldLoadHistory = workMinutes == nil && breakMinutes == nil && garden == nil
        let workMinutes = workMinutes ?? (shouldLoadHistory ? history.workMinutes : 30)
        let breakMinutes = breakMinutes ?? (shouldLoadHistory ? history.breakMinutes : 5)
        let garden = garden ?? (shouldLoadHistory ? history.garden : UserGarden())

        self.historyStore = historyStore
        self.workMinutes = workMinutes
        self.breakMinutes = breakMinutes
        self.phase = .work
        self.remainingSeconds = workMinutes * 60
        self.totalSeconds = workMinutes * 60
        self.isRunning = false
        self.garden = garden
        self.latestFlower = garden.flowers.first
        self.clockStyle = shouldLoadHistory ? history.clockStyle : .gardenBed
        self.activeFlowerKind = nil
    }

    deinit {
        ticker?.invalidate()
    }

    public var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1 - (Double(remainingSeconds) / Double(totalSeconds))
    }

    public var focusGrowthProgress: Double {
        phase == .work ? progress : 1
    }

    public var focusGrowthStage: FlowerGrowthStage {
        FlowerGrowthStage.stage(for: focusGrowthProgress)
    }

    public var isRunningFocus: Bool {
        isRunning && phase == .work
    }

    public var isRunningBreak: Bool {
        isRunning && phase == .break
    }

    public var isWorkSessionRewardEligible: Bool {
        workMinutes >= Self.minimumFlowerRewardMinutes
    }

    public var remainingTimeText: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    public var flowers: [Flower] {
        garden.flowers
    }

    public var gardenTitle: String {
        garden.userName == "You" ? "Your Garden" : "\(garden.userName)'s Garden"
    }

    public var stats: FocusStats {
        let calendar = Calendar.current
        let now = Date()
        let flowers = garden.flowers
        let today = flowers.filter { calendar.isDate($0.earnedAt, inSameDayAs: now) }.count
        let week = flowers.filter { calendar.isDate($0.earnedAt, equalTo: now, toGranularity: .weekOfYear) }.count
        let month = flowers.filter { calendar.isDate($0.earnedAt, equalTo: now, toGranularity: .month) }.count
        return FocusStats(today: today, thisWeek: week, thisMonth: month, total: flowers.count)
    }

    public func toggleRunning() {
        isRunning ? pause() : start()
    }

    public func start() {
        guard !isRunning else { return }
        prepareActiveFlowerIfNeeded()
        isRunning = true
        ticker = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    public func pause() {
        isRunning = false
        ticker?.invalidate()
        ticker = nil
    }

    public func reset() {
        pause()
        phase = .work
        totalSeconds = workMinutes * 60
        remainingSeconds = totalSeconds
        activeFlowerKind = nil
    }

    public func tick() {
        guard isRunning else { return }

        if remainingSeconds > 1 {
            remainingSeconds -= 1
            return
        }

        completeCurrentPhase()
    }

    @discardableResult
    public func addFlower(kind: FlowerKind = .random(), earnedAt: Date = Date()) -> Flower {
        let flower = Flower(kind: kind, earnedAt: earnedAt, focusMinutes: workMinutes)
        garden.flowers.insert(flower, at: 0)
        latestFlower = flower
        saveHistory()
        return flower
    }

    private func completeCurrentPhase() {
        switch phase {
        case .work:
            if isWorkSessionRewardEligible {
                addFlower(kind: activeFlowerKind ?? .random())
            }
            activeFlowerKind = nil
            phase = .break
            totalSeconds = breakMinutes * 60
            remainingSeconds = totalSeconds
        case .break:
            phase = .work
            totalSeconds = workMinutes * 60
            remainingSeconds = totalSeconds
        }
    }

    private func applySettingsChangeIfIdle() {
        guard !isRunning else { return }
        totalSeconds = phase == .work ? workMinutes * 60 : breakMinutes * 60
        remainingSeconds = totalSeconds
        saveHistory()
    }

    private func prepareActiveFlowerIfNeeded() {
        guard phase == .work, isWorkSessionRewardEligible, activeFlowerKind == nil else { return }
        activeFlowerKind = FlowerKind.random()
    }

    private func saveHistory() {
        historyStore.save(
            FocusHistorySnapshot(
                workMinutes: workMinutes,
                breakMinutes: breakMinutes,
                clockStyle: clockStyle,
                garden: garden
            )
        )
    }
}
