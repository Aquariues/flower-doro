import Foundation

public enum FlowerKind: String, CaseIterable, Identifiable, Equatable {
    case daisy
    case tulip
    case rose
    case sunflower
    case lavender

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .daisy:
            "Daisy"
        case .tulip:
            "Tulip"
        case .rose:
            "Rose"
        case .sunflower:
            "Sunflower"
        case .lavender:
            "Lavender"
        }
    }

    public var symbolName: String {
        switch self {
        case .daisy:
            "camera.macro"
        case .tulip:
            "leaf"
        case .rose:
            "seal"
        case .sunflower:
            "sun.max"
        case .lavender:
            "wand.and.stars"
        }
    }

    public static func random() -> FlowerKind {
        allCases.randomElement() ?? .daisy
    }
}

public struct Flower: Identifiable, Equatable {
    public let id: UUID
    public let kind: FlowerKind
    public let earnedAt: Date
    public let focusMinutes: Int

    public init(id: UUID = UUID(), kind: FlowerKind, earnedAt: Date = Date(), focusMinutes: Int) {
        self.id = id
        self.kind = kind
        self.earnedAt = earnedAt
        self.focusMinutes = focusMinutes
    }
}

public struct PendingFlowerClaim: Identifiable, Equatable {
    public let id: UUID
    public let completedAt: Date
    public let focusMinutes: Int

    public init(id: UUID = UUID(), completedAt: Date = Date(), focusMinutes: Int) {
        self.id = id
        self.completedAt = completedAt
        self.focusMinutes = focusMinutes
    }
}

public struct UserGarden: Identifiable, Equatable {
    public let id: UUID
    public var userName: String
    public var flowers: [Flower]

    public init(id: UUID = UUID(), userName: String = "You", flowers: [Flower] = []) {
        self.id = id
        self.userName = userName
        self.flowers = flowers
    }
}
