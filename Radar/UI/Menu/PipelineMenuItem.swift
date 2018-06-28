import AppKit
import Concourse

class PipelineMenuItem: NSMenuItem {
  var pipeline: Pipeline!
  var workspace: Workspace!
  
  init(_ pipeline: Pipeline, workspace: Workspace) {
    self.pipeline = pipeline
    self.workspace = workspace

    super.init(title: pipeline.name, action: #selector(handleClick(_:)), keyEquivalent: "")
    self.target = self
    self.image = NSImage(status: pipeline.status, transientStatus: pipeline.transientStatus)

    let menu = NSMenu()
    if pipeline.groups.count > 0 {
      for group in pipeline.groups {
        menu.addItem(GroupMenuItem(group, workspace: workspace))
      }
    } else {
      for job in pipeline.jobs {
        menu.addItem(JobMenuItem(job, workspace: workspace))
      }
    }

    self.submenu = menu
  }

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }

  @objc func handleClick(_ sender: NSMenuItem) {
    var path = "\(pipeline.target.api)/teams/\(pipeline.target.team)/pipelines/\(pipeline.name)"

    if pipeline.groups.count > 0 {
      var queries: [String] = []
      for group in pipeline.groups {
        queries.append("groups=\(group.name)")
      }
      path = "\(path)?\(queries.joined(separator: "&"))"
    }

    if let url = URL(string: path) {
      self.workspace.open(url)
    }
  }
}
