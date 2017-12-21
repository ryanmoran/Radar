import AppKit

protocol Workspace {
  func open(_ url: URL) -> Bool
}

extension NSWorkspace: Workspace {}
