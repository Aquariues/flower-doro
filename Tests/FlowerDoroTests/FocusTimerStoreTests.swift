import XCTest
@testable import FlowerDoro

@MainActor
final class FocusTimerStoreTests: XCTestCase {
    func testShortWorkCompletionDoesNotAddFlowerAndStartsBreak() {
        let store = FocusTimerStore(workMinutes: 1, breakMinutes: 5)

        store.start()
        for _ in 0..<60 {
            store.tick()
        }

        XCTAssertEqual(store.phase, .break)
        XCTAssertTrue(store.flowers.isEmpty)
        XCTAssertNil(store.latestFlower)
        XCTAssertNil(store.activeFlowerKind)
        XCTAssertEqual(store.remainingSeconds, 5 * 60)
    }

    func testThirtyMinuteWorkCompletionAutoAddsFlowerAndStartsBreak() {
        let store = FocusTimerStore(workMinutes: FocusTimerStore.minimumFlowerRewardMinutes, breakMinutes: 5)

        store.start()
        for _ in 0..<(FocusTimerStore.minimumFlowerRewardMinutes * 60) {
            store.tick()
        }

        XCTAssertEqual(store.phase, .break)
        XCTAssertEqual(store.flowers.count, 1)
        XCTAssertEqual(store.latestFlower, store.flowers.first)
        XCTAssertEqual(store.flowers.first?.focusMinutes, FocusTimerStore.minimumFlowerRewardMinutes)
        XCTAssertEqual(store.remainingSeconds, 5 * 60)
    }

    func testAddFlowerUsesSelectedKind() {
        let store = FocusTimerStore(workMinutes: 1, breakMinutes: 5)

        let flower = store.addFlower(kind: .rose)

        XCTAssertEqual(flower.kind, .rose)
        XCTAssertEqual(store.latestFlower, flower)
        XCTAssertEqual(store.garden.flowers.count, 1)
        XCTAssertEqual(store.garden.flowers.first?.focusMinutes, 1)
    }

    func testResetReturnsToConfiguredWorkSession() {
        let store = FocusTimerStore(workMinutes: 25, breakMinutes: 5)

        store.workMinutes = 45
        store.reset()

        XCTAssertEqual(store.phase, .work)
        XCTAssertEqual(store.remainingSeconds, 45 * 60)
        XCTAssertFalse(store.isRunning)
    }

    func testFlowerLibraryHasOneHundredLocalizedFlowers() {
        XCTAssertEqual(FlowerKind.allCases.count, 100)

        for kind in FlowerKind.allCases {
            XCTAssertFalse(kind.englishInfo.name.isEmpty)
            XCTAssertFalse(kind.vietnameseInfo.name.isEmpty)
            XCTAssertEqual(kind.englishInfo.facts.count, 3)
            XCTAssertEqual(kind.vietnameseInfo.facts.count, 3)
        }
    }
}
