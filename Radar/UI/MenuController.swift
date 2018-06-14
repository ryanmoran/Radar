import AppKit
import Concourse
import ConcourseAPI

class MenuController: NSObject {
  let statusItem: StatusItem

  init(workspace: Workspace) {
    self.statusItem = StatusItem(workspace: workspace)
    super.init()
  }
}

extension MenuController: Concourse.StateManagerDelegate {
  func stateDidChange(_ manager: Concourse.StateManager, state: Concourse.State) {
    statusItem.update(state: state)
  }
}
