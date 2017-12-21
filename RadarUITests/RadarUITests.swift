import XCTest

class RadarUITests: XCTestCase {
  var app = XCUIApplication()

  override func setUp() {
    super.setUp()
    continueAfterFailure = false

    app.launch()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testAppCanBeQuit() {
    XCTAssertEqual(app.state.rawValue, XCUIApplication.State.runningForeground.rawValue)

    let predicate = NSPredicate(format: "state == \(XCUIApplication.State.notRunning.rawValue)")
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: app)
    let menuBar = app.menuBars.element
    let quitMenuItem = menuBar.descendants(matching: XCUIElement.ElementType.menuItem).element(matching: NSPredicate(format: "title = \"Quit\""))

    menuBar.click()
    quitMenuItem.click()

    wait(for:[expectation], timeout: 5)
  }
}
