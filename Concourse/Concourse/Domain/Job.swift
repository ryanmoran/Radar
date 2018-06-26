import Foundation
import ConcourseAPI

public struct Job {
  let job: ConcourseAPI.Job
  public let pipeline: Concourse.Pipeline

  public init(_ job: ConcourseAPI.Job, pipeline: Concourse.Pipeline) {
    self.job = job
    self.pipeline = pipeline
  }

  public var id: Int {
    return job.id
  }

  public var name: String {
    return job.name
  }

  public var teamName: String {
    return job.teamName
  }

  public var pipelineName: String {
    return job.pipelineName
  }

  public var target: Target {
    return pipeline.target
  }

  public var status: String {
    if job.paused != nil {
      return "paused"
    }

    if let status = job.finishedBuild?.status {
      return status
    }

    return "unknown"
  }

  public var transientStatus: String {
    if let status = job.nextBuild?.status {
      return status
    }

    if job.paused != nil {
      return "paused"
    }

    if let status = job.finishedBuild?.status {
      return status
    }

    return "unknown"
  }

  public var build: Build? {
    if let build = job.nextBuild {
      return Build(build)
    }

    if let build = job.finishedBuild {
      return Build(build)
    }

    return nil
  }
}

extension Job: Equatable {
  public static func ==(lhs: Job, rhs: Job) -> Bool {
    return lhs.id == rhs.id
      && lhs.name == rhs.name
      && lhs.status == rhs.status
      && lhs.build == rhs.build
  }
}
