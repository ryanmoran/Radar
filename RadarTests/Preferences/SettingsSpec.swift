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
              <string>first-default-api</string>
              <key>team</key>
              <string>first-default-team</string>
            </dict>
            <dict>
              <key>api</key>
              <string>second-default-api</string>
              <key>team</key>
              <string>second-default-team</string>
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
      expect(firstTarget["api"]).to(equal("first-default-api"))
      expect(firstTarget["team"]).to(equal("first-default-team"))

      let secondTarget = targets[1]
      expect(secondTarget["api"]).to(equal("second-default-api"))
      expect(secondTarget["team"]).to(equal("second-default-team"))
    }

    it("pulls its data from the defaults") {
      defaults.arrayCall.returns.array = [
        [
          "api": "first-api",
          "team": "first-team"
        ],
        [
          "api": "second-api",
          "team": "second-team"
        ]
      ]

      expect(settings.targets).to(haveCount(2))
      expect(settings.targets).to(containElementSatisfying({ target in
        return target.api == "first-api" && target.team == "first-team"
      }))
      expect(settings.targets).to(containElementSatisfying({ target in
        return target.api == "second-api" && target.team == "second-team"
      }))
    }

    it("updates the list of targets") {
      settings.targets = [
        Settings.Target(api: "first-updated-api", team: "first-updated-team"),
        Settings.Target(api: "second-updated-api", team: "second-updated-team")
      ]

      expect(defaults.setCall.receives.key).to(equal("targets"))

      let targets = defaults.setCall.receives.value as! [[String: String]]
      expect(targets).to(containElementSatisfying({ target in
        return target["api"] == "first-updated-api" && target["team"] == "first-updated-team"
      }))
      expect(targets).to(containElementSatisfying({ target in
        return target["api"] == "second-updated-api" && target["team"] == "second-updated-team"
      }))
    }
  }
}
