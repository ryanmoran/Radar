import Foundation

public struct State {
  public var targets: [Target]

  public init() {
    self.targets = []
  }
}

extension State: Equatable {
  public static func ==(lhs: State, rhs: State) -> Bool {
    return lhs.targets == rhs.targets
  }
}
