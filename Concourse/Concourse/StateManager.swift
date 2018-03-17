import Foundation
import ConcourseAPI

public protocol StateManagerDelegate: class {
  func stateDidChange(_ manager: StateManager, state: State)
}

public protocol PipelineListable {
  func list(target: ConcourseAPI.HTTPClient) -> ([ConcourseAPI.Pipeline], Error?)
}

public protocol JobListable {
  func list(target: ConcourseAPI.HTTPClient, pipelineName: String) -> ([ConcourseAPI.Job], Error?)
}

extension ConcourseAPI.PipelinesService: PipelineListable {}
extension ConcourseAPI.JobsService: JobListable {}

public class StateManager {
  public let targets: [Target]
  public var delegates: [StateManagerDelegate]

  let pipelinesService: PipelineListable
  let jobsService: JobListable
  var state: State

  public init(targets: [Target], pipelinesService: PipelineListable, jobsService: JobListable) {
    self.state = State()
    self.targets = targets
    self.pipelinesService = pipelinesService
    self.jobsService = jobsService
    self.delegates = []
  }

  public func start() {
    DispatchQueue.global(qos: .background).async {
      self.fetchAndNotify()

      sleep(10)

      self.start()
    }
  }

  public func fetchAndNotify() {
    let (state, error) = self.fetch()
    if let error = error {
      // TODO: handle error
    }

    if self.state != state {
      for delegate in delegates {
        delegate.stateDidChange(self, state: state)
      }

      self.state = state
    }
  }

  public func fetch() -> (State, Error?) {
    var state = State()

    for target in targets {
      var target = Target(target.target)

      let (apiPipelines, error) = pipelinesService.list(target: target.target)
      if let error = error {
        // TODO: handle error
        return (State(), error)
      }

      for apiPipeline in apiPipelines {
        var pipeline = Pipeline(apiPipeline, target: target)

        let (apiJobs, error) = jobsService.list(target: target.target, pipelineName: apiPipeline.name)
        if let error = error {
          // TODO: handle error
          return (State(), error)
        }

        for apiJob in apiJobs {
          pipeline.jobs.append(Job(apiJob, pipeline: pipeline))
        }

        target.pipelines.append(pipeline)
      }

      state.targets.append(target)
    }

    return (state, nil)
  }
}
