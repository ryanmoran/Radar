import Foundation
import ConcourseAPI

public struct Target {
  let target: ConcourseAPI.Target
  public var pipelines: [Pipeline]

  public init(_ target: ConcourseAPI.Target) {
    self.target = target
    self.pipelines = []
  }

  public var api: String {
    return target.api
  }

  public var team: String {
    return target.team
  }
}

extension Target: Equatable {
  public static func ==(lhs: Target, rhs: Target) -> Bool {
    return lhs.api == rhs.api
      && lhs.team == rhs.team
      && lhs.pipelines == rhs.pipelines
  }
}
