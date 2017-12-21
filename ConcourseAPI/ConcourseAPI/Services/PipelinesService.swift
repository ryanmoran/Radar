import Foundation

public class PipelinesService {
  public init() {}

  public func list(target: HTTPClient) -> ([Pipeline], Error?) {
    var pipelines: [Pipeline] = []

    let (response, error) = target.get("/pipelines")
    if error != nil {
      return (pipelines, error)
    }

    do {
      pipelines = try JSONDecoder().decode([Pipeline].self, from: response.body)
    } catch {
      return (pipelines, error)
    }

    return (pipelines, nil)
  }
}
