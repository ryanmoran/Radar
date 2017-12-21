import AppKit
import Concourse

class ClickHandler {
  let workspace: Workspace

  init(workspace: Workspace) {
    self.workspace = workspace
  }

  @objc func handle(_ sender: NSMenuItem) {
    guard let url = sender.representedObject as! URL?
      else { return }

    self.workspace.open(url)
  }
}
