import Foundation

public class JobsService {
  public init() {}

  public func list(target: HTTPClient, pipelineName: String) -> ([Job], Error?) {
    var jobs: [Job] = []

    let (response, error) = target.get("/pipelines/\(pipelineName)/jobs")
    if let error = error {
      return (jobs, error)
    }

    do {
      jobs = try JSONDecoder().decode([Job].self, from: response.body)
    } catch {
      return (jobs, error)
    }

    return (jobs, nil)
  }
}
