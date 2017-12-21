import Quick
import Nimble
@testable import Radar

class TargetMenuItemSpec: QuickSpec {
  override func spec() {
    var item: TargetMenuItem!

    beforeEach {
      let target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      item = TargetMenuItem(target)
    }

    afterEach {
      item = nil
    }

    it("has a title") {
      expect(item.title).to(equal("some-api: some-team"))
    }
  }
}
