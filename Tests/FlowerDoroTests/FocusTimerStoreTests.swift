import XCTest
@testable import FlowerDoro

@MainActor
final class FocusTimerStoreTests: XCTestCase {
    func testWorkCompletionEarnsFlowerAndStartsBreak() {
        let store = FocusTimerStore(workMinutes: 1, breakMinutes: 5)

        store.start()
        for _ in 0..<60 {
            store.tick()
        }

        XCTAssertEqual(store.phase, .break)
        XCTAssertNotNil(store.pendingClaim)
        XCTAssertEqual(store.flowers.count, 0)
        XCTAssertEqual(store.remainingSeconds, 5 * 60)
    }

    func testClaimFlowerAddsSelectedFlowerToUserGarden() {
        let store = FocusTimerStore(workMinutes: 1, breakMinutes: 5)

        store.start()
        for _ in 0..<60 {
            store.tick()
        }

        let flower = store.claimFlower(kind: .rose)

        XCTAssertEqual(flower?.kind, .rose)
        XCTAssertNil(store.pendingClaim)
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
}
