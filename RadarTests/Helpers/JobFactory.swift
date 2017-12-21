import Concourse
import ConcourseAPI

class JobFactory {
  class func newJob(
    id: Int,
    name: String,
    finishedBuild: Concourse.Build?,
    nextBuild: Concourse.Build?,
    pipeline: Concourse.Pipeline
  ) -> Concourse.Job {

    let job = newAPIJob(id: id, name: name, finishedBuild: finishedBuild, nextBuild: nextBuild)

    return Concourse.Job(job, pipeline: pipeline)
  }

  class func newAPIJob(
    id: Int,
    name: String,
    finishedBuild: Concourse.Build?,
    nextBuild: Concourse.Build?
  ) -> ConcourseAPI.Job {

    var object: [String: Any] = [
      "id": id,
      "name": name
    ]

    if let build = finishedBuild {
      object["finished_build"] = [
        "id": build.id,
        "name": build.name,
        "status": build.status
      ]
    }

    if let build = nextBuild {
      object["next_build"] = [
        "id": build.id,
        "name": build.name,
        "status": build.status
      ]
    }

    let json = try! JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
    let job = try! JSONDecoder().decode(ConcourseAPI.Job.self, from: json)

    return job
  }
}
