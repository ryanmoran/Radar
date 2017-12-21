import Foundation

public struct Group {
  public let name: String
  public let pipeline: Pipeline
  public var jobs: [Job]

  public init(name: String, pipeline: Pipeline) {
    self.name = name
    self.pipeline = pipeline
    self.jobs = []
  }

  public var status: String {
    for status in ["paused", "started", "failed", "pending", "errored", "aborted", "succeeded"] {
      for job in jobs {
        if job.status == status {
          return status
        }
      }
    }

    return "unknown"
  }

  public var transientStatus: String {
    for status in ["started", "pending", "paused", "failed", "errored", "aborted", "succeeded"] {
      for job in jobs {
        if job.transientStatus == status {
          return status
        }
      }
    }

    return "unknown"
  }

  public var target: Target {
    return pipeline.target
  }
}

extension Group: Equatable {
  public static func ==(lhs: Group, rhs: Group) -> Bool {
    return lhs.name == rhs.name
      && lhs.jobs == rhs.jobs
  }
}

