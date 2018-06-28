import AppKit

class TargetsScrollViewController: NSViewController {
  let settings: Settings
  let targetsTableViewController: TargetsTableViewController

  init(settings: Settings) {
    self.settings = settings
    self.targetsTableViewController = TargetsTableViewController(settings: settings)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    let view = NSScrollView(frame: .zero)
    view.documentView = self.targetsTableViewController.view

    self.view = view
  }

  override func viewWillLayout() {
    super.viewWillLayout()

    if let superview = view.superview {
      let margin: CGFloat = 10.0
      let width = superview.frame.width - (margin + margin)
      let height = superview.frame.height - (margin + margin)

      view.frame = CGRect(x: margin, y: margin, width: width, height: height)
    }
  }
}
