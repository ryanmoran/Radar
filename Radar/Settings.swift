import Foundation

class Settings {
  let defaults: Defaults

  init(defaults: Defaults, url: URL) {
    let data = try! Data(contentsOf: url)
    let decodedDefaults = try! PropertyListDecoder().decode([String: [[String: String]]].self, from: data)

    self.defaults = defaults
    self.defaults.register(defaults: decodedDefaults)
  }
}

extension Settings {
  struct Target {
    let api: String
    let team: String
  }

  var targets: [Target] {
    var targets: [Target] = []

    guard let defaultsTargets = defaults.array(forKey: "targets") as! [[String: String]]? else { return targets }

    for defaultsTarget in defaultsTargets {
      guard let api = defaultsTarget["api"],
        let team = defaultsTarget["team"]
        else { return targets }

      targets.append(Target(api: api, team: team))
    }

    return targets
  }
}
