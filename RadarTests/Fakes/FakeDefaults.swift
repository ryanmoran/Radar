import Foundation
@testable import Radar

class FakeDefaults {
  var registerCall = RegisterCall()
  var arrayCall = ArrayCall()
  var setCall = SetCall()

  struct RegisterCall {
    var receives = Receives()

    struct Receives {
      var defaults: [String: Any]?
    }
  }

  struct ArrayCall {
    var receives = Receives()
    var returns = Returns()

    struct Receives {
      var key: String?
    }

    struct Returns {
      var array: [Any]?
    }
  }

  struct SetCall {
    var receives = Receives()

    struct Receives {
      var value: Any?
      var key: String?
    }
  }
}

extension FakeDefaults: Defaults {
  func register(defaults registrationDictionary: [String: Any]) {
    registerCall.receives.defaults = registrationDictionary
  }

  func array(forKey defaultName: String) -> [Any]? {
    arrayCall.receives.key = defaultName

    return arrayCall.returns.array
  }

  func set(_ value: Any?, forKey defaultName: String) {
    setCall.receives.value = value
    setCall.receives.key = defaultName
  }
}
