import Foundation
import Concourse

class TargetMenuItem: NSMenuItem {
  init(_ target: Target) {
    super.init(title: "\(target.api): \(target.team)", action: nil, keyEquivalent: "")
  }

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }
}
