import Foundation

public struct FocusStats: Equatable {
    public let today: Int
    public let thisWeek: Int
    public let thisMonth: Int
    public let total: Int
}

public struct FocusHistorySnapshot: Codable, Equatable {
    public var workMinutes: Int
    public var breakMinutes: Int
    public var clockStyle: ClockStyle
    public var garden: UserGarden

    public init(
        workMinutes: Int = 30,
        breakMinutes: Int = 5,
        clockStyle: ClockStyle = .gardenBed,
        garden: UserGarden = UserGarden()
    ) {
        self.workMinutes = workMinutes
        self.breakMinutes = breakMinutes
        self.clockStyle = clockStyle
        self.garden = garden
    }
}

public protocol FocusHistoryPersisting {
    func load() -> FocusHistorySnapshot
    func save(_ snapshot: FocusHistorySnapshot)
}

public struct FocusHistoryStore: FocusHistoryPersisting {
    private let fileURL: URL

    public init(
        fileManager: FileManager = .default,
        appFolderName: String = "FlowerDoro"
    ) {
        let baseURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.temporaryDirectory
        let folderURL = baseURL.appendingPathComponent(appFolderName, isDirectory: true)
        try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        self.fileURL = folderURL.appendingPathComponent("focus-history.json")
    }

    public func load() -> FocusHistorySnapshot {
        guard
            let data = try? Data(contentsOf: fileURL),
            let snapshot = try? JSONDecoder.iso8601Dates.decode(FocusHistorySnapshot.self, from: data)
        else {
            return FocusHistorySnapshot()
        }

        return snapshot
    }

    public func save(_ snapshot: FocusHistorySnapshot) {
        guard let data = try? JSONEncoder.prettySorted.encode(snapshot) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }
}

private extension JSONEncoder {
    static var prettySorted: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}

private extension JSONDecoder {
    static var iso8601Dates: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
