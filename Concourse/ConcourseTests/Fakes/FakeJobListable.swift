import Foundation
import Concourse
import ConcourseAPI

class FakeJobListable: JobListable {
  var listCall = ListCall()

  struct ListCall {
    var receives = Receives()
    var returns = Returns()

    struct Receives {
      var target: ConcourseAPI.HTTPClient?
      var pipelineName: String?
    }

    struct Returns {
      var jobs: [ConcourseAPI.Job] = []
      var error: Error?
    }
  }

  func list(target: ConcourseAPI.HTTPClient, pipelineName: String) -> ([ConcourseAPI.Job], Error?) {
    listCall.receives.target = target
    listCall.receives.pipelineName = pipelineName

    return (listCall.returns.jobs, listCall.returns.error)
  }
}
