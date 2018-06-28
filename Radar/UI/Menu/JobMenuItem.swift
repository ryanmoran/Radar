import AppKit
import Concourse

class JobMenuItem: NSMenuItem {
  var workspace: Workspace!
  var job: Job!

  init(_ job: Job, workspace: Workspace) {
    self.job = job
    self.workspace = workspace

    super.init(title: job.name, action: #selector(handleClick(_:)), keyEquivalent: "")
    self.target = self
    self.toolTip = "The state of the \(job.name) job in the \(job.pipeline.name) pipeline is \"\(job.status)\""
    self.image = NSImage.forStatus(status: job.status, transientStatus: job.transientStatus)
  }

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }

  @objc func handleClick(_ sender: NSMenuItem) {
    var path = "\(job.target.api)/teams/\(job.target.team)/pipelines/\(job.pipeline.name)/jobs/\(job.name)"
    if let build = job.build {
      path = "\(path)/builds/\(build.name)"
    }

    if let url = URL(string: path) {
      self.workspace.open(url)
    }
  }
}
