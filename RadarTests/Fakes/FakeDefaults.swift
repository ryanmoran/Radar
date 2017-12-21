import Foundation
@testable import Radar

class FakeDefaults {
  var registerCall = RegisterCall()
  var arrayCall = ArrayCall()

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
}

extension FakeDefaults: Defaults {
  func register(defaults registrationDictionary: [String: Any]) {
    registerCall.receives.defaults = registrationDictionary
  }

  func array(forKey defaultName: String) -> [Any]? {
    arrayCall.receives.key = defaultName

    return arrayCall.returns.array
  }
}
