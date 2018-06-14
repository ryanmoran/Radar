import AppKit
import Concourse

class StatusItem: NSObject {
  let workspace: Workspace
  let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  var targetGroups: [Concourse.Target: TargetGroup] = [:]

  var offset = 0.0
  var loaded = false
  var timer: Timer!

  var canUpdateMenu = true

  init(workspace: Workspace) {
    self.workspace = workspace

    super.init()

    item.menu = NSMenu()

    self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(rotate), userInfo:  nil, repeats: true)
  }

  @objc func rotate() {
    if loaded && offset == 0 {
      timer.invalidate()
      timer = nil
      return
    }

    offset = (offset + 10.0).truncatingRemainder(dividingBy: 360.0)

    if let button = item.button {
      let image = NSImage(named: NSImage.Name("radar"))!
      button.image = image.rotatedBy(degrees: CGFloat(360.0 - offset))
    }
  }

  func update(state: Concourse.State) {
    loaded = true
    print("update called")

    updateTargets(state.targets)
    updateQuit()

    for item in (item.menu?.items)! {
//      print(item)
    }
  }

  func updateQuit() {
    guard let menu = item.menu else { return }

    for item in menu.items {
      if item.title == "Quit" {
        return
      }
    }

    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
  }

  func updateTargets(_ targets: [Concourse.Target]) {
    guard let menu = item.menu else { return }

    for target in targets {
      if targetGroups[target] == nil {
        targetGroups[target] = TargetGroup(target: target, menu: menu, workspace: workspace)
      }

      if let group = targetGroups[target] {
        group.update(target)
      }
    }
  }

//    var group: TargetGroup?
//
//    for target in targets {
//      print(target)
//      for targetGroup in targetGroups {
//        print(targetGroup)
//        if target == targetGroup.target {
//          group = targetGroup
//          break
//        }
//      }
//
//      if group == nil {
//        if let menu = item.menu {
//          group = TargetGroup(target: target, menu: menu, workspace: self.workspace)
//          targetGroups.append(group)
//        }
//      }
//
//      group.update(target)

  class TargetGroup {
    var target: Concourse.Target
    let menu: NSMenu
    let workspace: Workspace

    init(target: Concourse.Target, menu: NSMenu, workspace: Workspace) {
      self.target = target
      self.menu = menu
      self.workspace = workspace
    }

    func update(_ target: Concourse.Target) {
      menu.addItem(TargetMenuItem(target))

      for pipeline in target.pipelines {
        menu.addItem(PipelineMenuItem(pipeline, workspace: workspace))
      }

      menu.addItem(NSMenuItem.separator())
    }
  }
}
