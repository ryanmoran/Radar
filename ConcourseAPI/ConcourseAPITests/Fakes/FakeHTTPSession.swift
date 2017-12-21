import Foundation
import ConcourseAPI

class FakeHTTPSession: HTTPSession {
  var synchronousDataTaskCall = SynchronousDataTaskCall()

  struct SynchronousDataTaskCall {
    var receives = Receives()
    var returns = Returns()

    struct Receives {
      var with: URL?
    }

    struct Returns {
      var data: Data?
      var urlResponse: URLResponse?
      var error: Error?
    }
  }

  func synchronousDataTask(with: URL) -> (Data?, URLResponse?, Error?) {
    synchronousDataTaskCall.receives.with = with

    return (
      synchronousDataTaskCall.returns.data,
      synchronousDataTaskCall.returns.urlResponse,
      synchronousDataTaskCall.returns.error
    )
  }
}
