@testable import Concourse
@testable import ConcourseAPI

class GroupFactory {
  class func newGroup(name: String, jobs: [Concourse.Job], pipeline: Concourse.Pipeline) -> Concourse.Group {

    var group = Concourse.Group(name: name, pipeline: pipeline)
    for job in jobs {
      group.jobs.append(job)
    }

    return group
  }

  class func newAPIGroup(name: String, jobs: [String]) -> ConcourseAPI.Pipeline.Group {
    return ConcourseAPI.Pipeline.Group(name: name, jobs: jobs)
  }
}
