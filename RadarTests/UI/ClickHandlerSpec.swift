import Quick
import Nimble
import AppKit
@testable import Radar

class ClickHandlerSpec: QuickSpec {
  override func spec() {
    var workspace: FakeWorkspace!
    var handler: ClickHandler!

    beforeEach {
      workspace = FakeWorkspace()
      handler = ClickHandler(workspace: workspace)
    }

    afterEach {
      handler = nil
      workspace = nil
    }

    it("opens the url for the clicked menu item") {
      let menuItem = NSMenuItem()
      menuItem.representedObject = URL(string: "some-url")

      handler.handle(menuItem)
      expect(workspace.openCall.receives.url).to(equal(URL(string:"some-url")))
    }
  }
}
