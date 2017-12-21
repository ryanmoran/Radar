import Foundation
@testable import Radar

class FakeWorkspace {
  var openCall = OpenCall()

  struct OpenCall {
    var receives = Receives()
    var returns = Returns()

    struct Receives {
      var url: URL?
    }

    struct Returns {
      var bool = false
    }
  }
}

extension FakeWorkspace : Workspace {
  func open(_ url: URL) -> Bool {
    self.openCall.receives.url = url

    return self.openCall.returns.bool
  }
}
