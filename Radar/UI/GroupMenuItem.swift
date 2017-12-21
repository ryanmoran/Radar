import AppKit
import Concourse

class GroupMenuItem: NSMenuItem {
  init(_ group: Group, handler: ClickHandler) {
    super.init(title: group.name, action: #selector(handler.handle(_:)), keyEquivalent: "")
    self.target = handler
    self.image = NSImage(status: group.status, transientStatus: group.transientStatus)
    self.representedObject = URL(string: "\(group.target.api)/teams/\(group.target.team)/pipelines/\(group.pipeline.name)?groups=\(group.name)")

    let menu = NSMenu()
    for job in group.jobs {
      menu.addItem(JobMenuItem(job, handler: handler))
    }
    self.submenu = menu
  }

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }
}
