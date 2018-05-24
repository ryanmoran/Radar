import os.log
import Concourse

protocol Loggable {
  func error(message: String, error: Error)
}

public class Logger {
  let log: OSLog

  public init(log: OSLog) {
    self.log = log
  }
}

extension Logger: Loggable, Concourse.Loggable {
  public func error(message: String, error: Error) {
    os_log("%{public}@: %{public}@", log: log, type: .error, message, error as CVarArg)
  }
}
