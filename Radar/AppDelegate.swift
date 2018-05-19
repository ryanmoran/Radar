import AppKit
import os.log
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
    let logger = Concourse.Logger(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "general"))

    var targets: [Concourse.Target] = []
    for target in settings.targets {
      targets.append(Concourse.Target(ConcourseAPI.Target(session: URLSession.shared, api: target.api, team: target.team)))
    }

    let pipelinesService = ConcourseAPI.PipelinesService()
    let jobsService = ConcourseAPI.JobsService()

    stateManager = Concourse.StateManager(logger: logger, targets: targets, pipelinesService: pipelinesService, jobsService: jobsService)

    menuController = MenuController(workspace: NSWorkspace.shared)
    stateManager.delegates.append(menuController)

    menuController.load()
    stateManager.start()
  }
}
