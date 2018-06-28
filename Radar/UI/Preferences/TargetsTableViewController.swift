import AppKit

let DeleteKeyCode = 51

class TargetsTableViewController: NSViewController {
  let settings: Settings
  var tableView: NSTableView?

  init(settings: Settings) {
    self.settings = settings
    
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    let view = NSTableView(frame: .zero)

    self.tableView = view
    self.view = view
  }

  override func viewDidLoad() {
    if let view = self.tableView {
      view.dataSource = self
      view.addTableColumn(column(withName: "api"))
      view.addTableColumn(column(withName: "team"))
      view.columnAutoresizingStyle = .reverseSequentialColumnAutoresizingStyle
      view.usesAlternatingRowBackgroundColors = true
    }
  }

  override func viewWillLayout() {
    super.viewWillLayout()
    
    if let superview = view.superview {
      view.frame = superview.frame
    }
  }

  func column(withName name: String) -> NSTableColumn {
    let column = NSTableColumn()
    column.headerCell = NSTableHeaderCell(textCell: name)

    return column
  }

  override func keyDown(with event: NSEvent) {
    super.keyDown(with: event)

    if event.keyCode == DeleteKeyCode {
      if let view = self.tableView {
        let indexes = view.selectedRowIndexes
        var targets: [Settings.Target] = []

        for i in indexes {
          for (j, target) in self.settings.targets.enumerated() {
            if i != j {
              targets.append(target)
            }
          }
        }

        view.beginUpdates()
        self.settings.targets = targets
        view.removeRows(at: indexes, withAnimation: .slideUp)
        view.endUpdates()
      }
    }
  }
}

extension TargetsTableViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.settings.targets.count
  }

  func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
    let target = self.settings.targets[row]

    if let column = tableColumn {
      switch column.title {
      case "api":
        return target.api
      case "team":
        return target.team
      default:
        return nil
      }
    }

    return nil
  }

  func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
    let value = object as! String
    var targets: [Settings.Target] = []

    for (i, t) in self.settings.targets.enumerated() {
      var target = Settings.Target(api: t.api, team: t.team)

      if i == row {
        if let column = tableColumn {
          switch column.title {
          case "api":
            target = Settings.Target(api: value, team: t.team)
          default:
            target = Settings.Target(api: t.api, team: value)
          }
        }
      }

      targets.append(target)
    }

    self.settings.targets = targets
  }
}
