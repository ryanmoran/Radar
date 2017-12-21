import Concourse
import ConcourseAPI

class BuildFactory {
  class func newBuild(id: Int, name: String, status: String) -> Concourse.Build {
    let object: [String: Any] = [
      "id": id,
      "name": name,
      "status": status
    ]

    let json = try! JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
    let build = try! JSONDecoder().decode(ConcourseAPI.Build.self, from: json)

    return Concourse.Build(build)
  }
}
