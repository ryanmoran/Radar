import AppKit
import Concourse

class GroupMenuItem: NSMenuItem {
  var group: Group!
  var workspace: Workspace!

  init(_ group: Group, workspace: Workspace) {
    self.group = group
    self.workspace = workspace

    super.init(title: group.name, action: #selector(handleClick(_:)), keyEquivalent: "")
    self.target = self
    self.image = NSImage(status: group.status, transientStatus: group.transientStatus)

    let menu = NSMenu()
    for job in group.jobs {
      menu.addItem(JobMenuItem(job, workspace: workspace))
    }
    self.submenu = menu
  }

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }

  @objc func handleClick(_ sender: NSMenuItem) {
    let path = "\(group.target.api)/teams/\(group.target.team)/pipelines/\(group.pipeline.name)?groups=\(group.name)"

    if let url = URL(string: path) {
      self.workspace.open(url)
    }
  }
}
