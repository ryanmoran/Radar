//
//  Logger.swift
//  Concourse
//
//  Created by Ryan Moran on 5/19/18.
//  Copyright © 2018 banana. All rights reserved.
//

import os.log

public protocol Loggable {
  func error(message: String, error: Error)
}

public class Logger {
  let log: OSLog

  public init(log: OSLog) {
    self.log = log
  }
}

extension Logger: Loggable {
  public func error(message: String, error: Error) {
    os_log("%@: %@", log: log, type: .error, message, error as CVarArg)
  }
}
