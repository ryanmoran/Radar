import Concourse
import ConcourseAPI

class TargetFactory {
  class func newTarget(api: String, team: String) -> Concourse.Target {
    let target = ConcourseAPI.Target(session: URLSession.shared, api: api, team: team)

    return Concourse.Target(target)
  }
}
