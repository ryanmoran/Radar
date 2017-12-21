import Foundation
import ConcourseAPI

public struct Build {
  let build: ConcourseAPI.Build

  public init(_ build: ConcourseAPI.Build) {
    self.build = build
  }

  public var id: Int {
    return build.id
  }

  public var name: String {
    return build.name
  }

  public var status: String {
    return build.status
  }
}

extension Build: Equatable {
  public static func ==(lhs: Build, rhs: Build) -> Bool {
    return lhs.id == rhs.id
      && lhs.name == rhs.name
      && lhs.status == rhs.status
  }
}
