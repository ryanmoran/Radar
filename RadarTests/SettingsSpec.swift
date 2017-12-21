import Quick
import Nimble
@testable import Radar

class SettingsSpec: QuickSpec {
  override func spec() {
    var plistURL: URL!
    var settings: Settings!
    var defaults: FakeDefaults!

    beforeEach {
      plistURL = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(UUID().uuidString)
        .appendingPathExtension("plist")

      let plist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>targets</key>
          <array>
            <dict>
              <key>api</key>
              <string>some-api</string>
              <key>team</key>
              <string>some-team</string>
            </dict>
            <dict>
              <key>api</key>
              <string>other-api</string>
              <key>team</key>
              <string>other-team</string>
            </dict>
          </array>
        </dict>
        </plist>
      """

      try? plist.write(to: plistURL, atomically: false, encoding: .utf8)

      defaults = FakeDefaults()

      settings = Settings(defaults: defaults, url: plistURL)
    }

    afterEach {
      settings = nil
      defaults = nil

      try? FileManager.default.removeItem(at: plistURL)
      plistURL = nil
    }

    it("registers itself with the user defaults") {
      let dict = defaults.registerCall.receives.defaults!

      let targets = dict["targets"] as! [[String: String]]
      expect(targets).to(haveCount(2))

      let firstTarget = targets[0]
      expect(firstTarget["api"]).to(equal("some-api"))
      expect(firstTarget["team"]).to(equal("some-team"))

      let secondTarget = targets[1]
      expect(secondTarget["api"]).to(equal("other-api"))
      expect(secondTarget["team"]).to(equal("other-team"))
    }

    it("pulls its data from the defaults") {
      defaults.arrayCall.returns.array = [
        ["api": "new-api", "team": "new-team"]
      ]

      expect(settings.targets).to(haveCount(1))
      expect(settings.targets).to(containElementSatisfying({ target in
        return target.api == "new-api" && target.team == "new-team"
      }))
    }
  }
}
