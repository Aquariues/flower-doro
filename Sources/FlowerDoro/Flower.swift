import Foundation

public struct Flower: Identifiable, Equatable {
    public let id: UUID
    public let earnedAt: Date
    public let focusMinutes: Int

    public init(id: UUID = UUID(), earnedAt: Date = Date(), focusMinutes: Int) {
        self.id = id
        self.earnedAt = earnedAt
        self.focusMinutes = focusMinutes
    }
}
