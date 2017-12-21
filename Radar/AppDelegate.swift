import AppKit
import Concourse
import ConcourseAPI

@NSApplicationMain
class AppDelegate: NSObject {
  var menuController: MenuController!
  var stateManager: Concourse.StateManager!

  override init() {
    super.init()
  }
}

// MARK: - NSApplicationDelegate
extension AppDelegate: NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    let defaults = Bundle.main.url(forResource: "DefaultPreferences", withExtension: "plist")!
    let settings = Settings(defaults: UserDefaults.standard, url: defaults)

    var targets: [Concourse.Target] = []
    for target in settings.targets {
      targets.append(Concourse.Target(ConcourseAPI.Target(session: URLSession.shared, api: target.api, team: target.team)))
    }

    let pipelinesService = ConcourseAPI.PipelinesService()
    let jobsService = ConcourseAPI.JobsService()

    let clickHandler = ClickHandler(workspace: NSWorkspace.shared)

    menuController = MenuController(clickHandler: clickHandler)

    stateManager = Concourse.StateManager(targets: targets, pipelinesService: pipelinesService, jobsService: jobsService)
    stateManager.delegate = menuController

    menuController.load()
    stateManager.start()
  }
}
