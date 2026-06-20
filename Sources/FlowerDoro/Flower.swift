import Foundation

public enum FlowerKind: String, CaseIterable, Identifiable, Equatable {
    case daisy
    case rose
    case sunflower

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .daisy:
            "Daisy"
        case .rose:
            "Rose"
        case .sunflower:
            "Sunflower"
        }
    }

    public var assetName: String {
        rawValue
    }

    public var symbolName: String {
        switch self {
        case .daisy:
            "camera.macro"
        case .rose:
            "seal"
        case .sunflower:
            "sun.max"
        }
    }

    public static func random() -> FlowerKind {
        allCases.randomElement() ?? .daisy
    }
}

public enum ClockStyle: String, CaseIterable, Identifiable, Equatable {
    case outline
    case petal
    case gardenBed

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .outline:
            "Outline"
        case .petal:
            "Petal"
        case .gardenBed:
            "Garden Bed"
        }
    }
}

public enum FlowerGrowthStage: String, Equatable {
    case seed
    case sprout
    case bud
    case bloom

    public static func stage(for progress: Double) -> FlowerGrowthStage {
        switch min(max(progress, 0), 1) {
        case 0..<0.25:
            .seed
        case 0.25..<0.55:
            .sprout
        case 0.55..<0.9:
            .bud
        default:
            .bloom
        }
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
