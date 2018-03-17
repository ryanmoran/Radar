import Foundation
import Concourse

class FakeStateManagerDelegate: StateManagerDelegate {
  var stateDidChangeCall = StateDidChangeCall()

  struct StateDidChangeCall {
    var receives = Receives()

    struct Receives {
      var manager: StateManager?
      var state: State?
    }
  }

  func stateDidChange(_ manager: StateManager, state: State) {
    stateDidChangeCall.receives.manager = manager
    stateDidChangeCall.receives.state = state
  }
}
