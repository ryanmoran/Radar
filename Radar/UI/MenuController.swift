import AppKit
import Concourse
import ConcourseAPI

class MenuController: NSObject {
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  var offset = 0.0
  var loaded = false
  var timer: Timer!
  var workspace: Workspace

  init(workspace: Workspace) {
    self.workspace = workspace

    super.init()

    statusItem.menu = NSMenu()

    if let menu = statusItem.menu {
      menu.addItem(NSMenuItem(title:"Loading...", action: nil, keyEquivalent: ""))
      menu.addItem(NSMenuItem.separator())
      menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
  }

  func load() {
    timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(rotate), userInfo:  nil, repeats: true)
  }

  @objc func rotate() {
    if loaded && offset == 0 {
      timer.invalidate()
      timer = nil
      return
    }

    offset = (offset + 10.0).truncatingRemainder(dividingBy: 360.0)

    if let button = statusItem.button {
      let image = NSImage(named: NSImage.Name("radar"))!
      button.image = image.rotatedBy(degrees: CGFloat(360.0 - offset))
    }
  }
}

extension MenuController: Concourse.StateManagerDelegate {
  func stateDidChange(_ manager: Concourse.StateManager, state: Concourse.State) {
    loaded = true

    guard let menu = statusItem.menu else { return }
    menu.removeAllItems()

    for target in state.targets {
      menu.addItem(TargetMenuItem(target))
      for pipeline in target.pipelines {
        menu.addItem(PipelineMenuItem(pipeline, workspace: self.workspace))
      }
      menu.addItem(NSMenuItem.separator())
    }
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
  }
}
