import Foundation

@MainActor
public final class FocusTimerStore: ObservableObject {
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

    private var totalSeconds: Int
    private var ticker: Timer?

    public init(workMinutes: Int = 30, breakMinutes: Int = 5, garden: UserGarden = UserGarden()) {
        self.workMinutes = workMinutes
        self.breakMinutes = breakMinutes
        self.phase = .work
        self.remainingSeconds = workMinutes * 60
        self.totalSeconds = workMinutes * 60
        self.isRunning = false
        self.garden = garden
        self.latestFlower = garden.flowers.first
    }

    deinit {
        ticker?.invalidate()
    }

    public var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1 - (Double(remainingSeconds) / Double(totalSeconds))
    }

    public var isRunningFocus: Bool {
        isRunning && phase == .work
    }

    public var isRunningBreak: Bool {
        isRunning && phase == .break
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

    public func toggleRunning() {
        isRunning ? pause() : start()
    }

    public func start() {
        guard !isRunning else { return }
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
        return flower
    }

    private func completeCurrentPhase() {
        switch phase {
        case .work:
            addFlower()
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
    }
}
