import AppKit
import Concourse

class JobMenuItem: NSMenuItem {
  init(_ job: Job, handler: ClickHandler) {
    super.init(title: job.name, action: #selector(handler.handle(_:)), keyEquivalent: "")
    self.target = handler
    self.toolTip = "The state of the \(job.name) job in the \(job.pipeline.name) pipeline is \"\(job.status)\""
    self.image = NSImage(status: job.status, transientStatus: job.transientStatus)

    var path = "\(job.target.api)/teams/\(job.target.team)/pipelines/\(job.pipeline.name)/jobs/\(job.name)"
    if let build = job.build {
      path = "\(path)/builds/\(build.name)"
    }
    self.representedObject = URL(string: path)
  }

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }
}
