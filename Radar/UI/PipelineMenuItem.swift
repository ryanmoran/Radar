import AppKit
import Concourse

class PipelineMenuItem: NSMenuItem {
  init(_ pipeline: Pipeline, handler: ClickHandler) {
    super.init(title: pipeline.name, action: #selector(handler.handle(_:)), keyEquivalent: "")
    self.target = handler
    self.image = NSImage(status: pipeline.status, transientStatus: pipeline.transientStatus)

    var path = "\(pipeline.target.api)/teams/\(pipeline.target.team)/pipelines/\(pipeline.name)"

    let menu = NSMenu()
    if pipeline.groups.count > 0 {
      var queries: [String] = []
      for group in pipeline.groups {
        menu.addItem(GroupMenuItem(group, handler: handler))
        queries.append("groups=\(group.name)")
      }
      path = "\(path)?\(queries.joined(separator: "&"))"
    } else {
      for job in pipeline.jobs {
        menu.addItem(JobMenuItem(job, handler: handler))
      }
    }

    self.representedObject = URL(string: path)
    self.submenu = menu
  }

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }
}
