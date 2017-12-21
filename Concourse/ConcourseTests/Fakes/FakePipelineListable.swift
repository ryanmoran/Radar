import Foundation
import Concourse
import ConcourseAPI

class FakePipelineListable: PipelineListable {
  var listCall = ListCall()

  struct ListCall {
    var receives = Receives()
    var returns = Returns()

    struct Receives {
      var target: ConcourseAPI.HTTPClient?
    }

    struct Returns {
      var pipelines: [ConcourseAPI.Pipeline] = []
      var error: Error?
    }
  }

  func list(target: ConcourseAPI.HTTPClient) -> ([ConcourseAPI.Pipeline], Error?) {
    listCall.receives.target = target

    return (listCall.returns.pipelines, listCall.returns.error)
  }
}
