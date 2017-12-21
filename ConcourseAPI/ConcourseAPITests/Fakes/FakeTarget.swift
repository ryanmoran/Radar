import Foundation
import ConcourseAPI

class FakeTarget: HTTPClient {
  var getCall = GetCall()

  struct GetCall {
    var receives = Receives()
    var returns = Returns()

    struct Receives {
      var path = ""
    }

    struct Returns {
      var response = HTTPResponse()
      var error: Error?
    }
  }

  func get(_ path: String) -> (HTTPResponse, Error?) {
    getCall.receives.path = path

    return (getCall.returns.response, getCall.returns.error)
  }
}
