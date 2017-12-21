import Foundation
import ConcourseAPI

public struct Pipeline {
  let pipeline: ConcourseAPI.Pipeline
  public let target: Target
  public var jobs: [Job]

  public init(_ pipeline: ConcourseAPI.Pipeline, target: Target) {
    self.pipeline = pipeline
    self.target = target
    self.jobs = []
  }

  public var id: Int {
    return pipeline.id
  }

  public var name: String {
    return pipeline.name
  }

  public var groups: [Group] {
    var groups: [Group] = []

    if let apiGroups = pipeline.groups {
      for apiGroup in apiGroups {
        var group = Group(name: apiGroup.name, pipeline: self)

        for jobName in apiGroup.jobs {
          for job in jobs {
            if job.name == jobName {
              group.jobs.append(job)
            }
          }
        }

        groups.append(group)
      }
    }

    return groups
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
}

extension Pipeline: Equatable {
  public static func ==(lhs: Pipeline, rhs: Pipeline) -> Bool {
    return lhs.id == rhs.id
      && lhs.name == rhs.name
      && lhs.groups == rhs.groups
      && lhs.jobs == rhs.jobs
  }
}
