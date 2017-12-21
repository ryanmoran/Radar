import Concourse
import ConcourseAPI

class PipelineFactory {
  class func newPipeline(id: Int, name: String, target: Concourse.Target, groups: [Concourse.Group]) -> Concourse.Pipeline {
    var apiGroups: [ConcourseAPI.Pipeline.Group] = []
    for group in groups {
      apiGroups.append(GroupFactory.newAPIGroup(name: group.name, jobs: group.jobs.map({ job in return job.name })))
    }

    let apiPipeline = newAPIPipeline(id: id, name: name, groups: apiGroups)
    return Concourse.Pipeline(apiPipeline, target: target)
  }

  class func newAPIPipeline(id: Int, name: String, groups: [ConcourseAPI.Pipeline.Group]) -> ConcourseAPI.Pipeline {
    var object: [String: Any] = [
      "id": id,
      "name": name
    ]

    var groupObjects: [[String: Any]] = []

    for group in groups {
      groupObjects.append(["name": group.name, "jobs": group.jobs])
    }

    if groupObjects.count > 0 {
      object["groups"] = groupObjects
    }

    let json = try! JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
    let pipeline = try! JSONDecoder().decode(ConcourseAPI.Pipeline.self, from: json)

    return pipeline
  }
}
