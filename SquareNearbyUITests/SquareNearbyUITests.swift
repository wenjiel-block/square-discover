import XCTest

final class SquareNearbyUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunches() throws {
        let app = XCUIApplication()
        app.launch()

        // Placeholder: verify the app launches and the tab bar is visible.
        XCTAssertTrue(app.tabBars.firstMatch.exists)
    }
}
