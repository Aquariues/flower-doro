import Foundation

public enum FlowerKind: String, CaseIterable, Codable, Identifiable, Equatable {
    case daisy
    case rose
    case sunflower
    case tulip
    case lotus
    case lavender
    case orchid
    case cherryBlossom
    case poppy
    case hydrangea

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .daisy:
            "Daisy"
        case .rose:
            "Rose"
        case .sunflower:
            "Sunflower"
        case .tulip:
            "Tulip"
        case .lotus:
            "Lotus"
        case .lavender:
            "Lavender"
        case .orchid:
            "Orchid"
        case .cherryBlossom:
            "Cherry Blossom"
        case .poppy:
            "Poppy"
        case .hydrangea:
            "Hydrangea"
        }
    }

    public var assetName: String {
        switch self {
        case .cherryBlossom:
            "cherry-blossom"
        default:
            rawValue
        }
    }

    public var symbolName: String {
        switch self {
        case .daisy:
            "camera.macro"
        case .rose:
            "seal"
        case .sunflower:
            "sun.max"
        case .tulip:
            "tulip"
        case .lotus:
            "water.waves"
        case .lavender:
            "leaf"
        case .orchid:
            "camera.macro"
        case .cherryBlossom:
            "sparkle"
        case .poppy:
            "circle.hexagongrid"
        case .hydrangea:
            "circle.grid.3x3.circle"
        }
    }

    public var shortDescription: String {
        switch self {
        case .daisy:
            "A bright field flower often linked with fresh starts and simple joy."
        case .rose:
            "A classic garden bloom known for layered petals, fragrance, and symbolism."
        case .sunflower:
            "A tall, sunny bloom famous for turning its face toward the light."
        case .tulip:
            "A spring bulb flower with smooth cup-shaped petals and bold colors."
        case .lotus:
            "A water flower that rises from muddy ponds and opens clean above the surface."
        case .lavender:
            "A fragrant purple herb-flower often used for calm scents and small bouquets."
        case .orchid:
            "An elegant flower family with sculptural petals and many rare-looking shapes."
        case .cherryBlossom:
            "A delicate spring blossom admired for its soft pink petals and short bloom season."
        case .poppy:
            "A vivid, papery flower with a dark center and a strong wildflower silhouette."
        case .hydrangea:
            "A round cluster flower whose color can shift with soil conditions."
        }
    }

    public var facts: [String] {
        switch self {
        case .daisy:
            [
                "Its name is linked to “day’s eye” because many daisies open with daylight.",
                "Daisies are composite flowers, made from many tiny florets.",
                "They often symbolize innocence, hope, and new beginnings."
            ]
        case .rose:
            [
                "Roses have been cultivated for thousands of years.",
                "Different rose colors are often used to express different feelings.",
                "Many rose varieties are prized for their natural fragrance."
            ]
        case .sunflower:
            [
                "Young sunflowers can track the sun across the sky.",
                "A sunflower head is made of many small flowers packed together.",
                "Sunflowers are known for their seeds as well as their bright petals."
            ]
        case .tulip:
            [
                "Tulips grow from bulbs and are strongly associated with spring.",
                "They became famously valuable during the Dutch tulip trade.",
                "Their clean cup shape makes them popular in simple bouquets."
            ]
        case .lotus:
            [
                "Lotus leaves are naturally water-repellent.",
                "The flower is often used as a symbol of renewal and resilience.",
                "Lotus plants root in mud while their flowers rise above the water."
            ]
        case .lavender:
            [
                "Lavender is loved for its calming scent.",
                "Its purple flower spikes attract pollinators.",
                "Dried lavender keeps its fragrance for a long time."
            ]
        case .orchid:
            [
                "Orchids are one of the largest flowering plant families.",
                "Many orchids have highly specialized bloom shapes.",
                "Some orchids can flower for weeks when cared for well."
            ]
        case .cherryBlossom:
            [
                "Cherry blossoms are celebrated in spring festivals.",
                "Their short bloom season is part of their charm.",
                "The flowers usually appear before or with the first leaves."
            ]
        case .poppy:
            [
                "Poppies are known for thin, papery petals.",
                "Many poppies thrive in open sunny places.",
                "Red poppies are widely used as symbols of remembrance."
            ]
        case .hydrangea:
            [
                "Hydrangea blooms are made from clusters of many small flowers.",
                "Some hydrangeas change color depending on soil acidity.",
                "They are popular because one plant can produce large, full blooms."
            ]
        }
    }

    public static func random() -> FlowerKind {
        allCases.randomElement() ?? .daisy
    }
}

public enum ClockStyle: String, CaseIterable, Codable, Identifiable, Equatable {
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

public enum FlowerGrowthStage: String, Codable, Equatable {
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

public struct Flower: Codable, Identifiable, Equatable {
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

public struct UserGarden: Codable, Identifiable, Equatable {
    public let id: UUID
    public var userName: String
    public var flowers: [Flower]

    public init(id: UUID = UUID(), userName: String = "You", flowers: [Flower] = []) {
        self.id = id
        self.userName = userName
        self.flowers = flowers
    }
}
