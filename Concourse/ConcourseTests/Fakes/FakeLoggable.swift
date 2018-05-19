//
//  FakeLoggable.swift
//  ConcourseTests
//
//  Created by Ryan Moran on 5/19/18.
//  Copyright © 2018 banana. All rights reserved.
//

import Foundation
import Concourse

class FakeLoggable: Loggable {
  var errorCall = ErrorCall()

  struct ErrorCall {
    var receives = Receives()

    struct Receives {
      var message: String?
      var error: Error?
    }
  }

  func error(message: String, error: Error) {
    errorCall.receives.message = message
    errorCall.receives.error = error
  }
}
