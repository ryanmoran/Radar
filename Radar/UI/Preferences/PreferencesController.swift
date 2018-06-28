import AppKit

class PreferencesController: NSWindowController {
  let settings: Settings
  let targetsScrollViewController: TargetsScrollViewController

  init(settings: Settings) {
    self.settings = settings
    self.targetsScrollViewController = TargetsScrollViewController(settings: settings)

    let bounds = CGRect(x: 0, y: 0, width: 500, height: 300)
    let window = NSWindow(contentRect: bounds, styleMask: [.closable, .titled], backing: .buffered, defer: true)

    super.init(window: window)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showWindow(_ sender: Any?) {
    if let window = window {
      if let contentView = window.contentView {
        contentView.addSubview(targetsScrollViewController.view)
      }

      window.center()
    }

    NSApp.activate(ignoringOtherApps: true)
    super.showWindow(sender)
  }
}
