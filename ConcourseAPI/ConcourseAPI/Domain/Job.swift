import Foundation

public struct Job: Decodable {
  public let id: Int
  public let name: String
  public let paused: Bool?
  public let teamName: String
  public let pipelineName: String
  public let nextBuild: Build?
  public let finishedBuild: Build?
  public let transitionBuild: Build?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case paused
    case teamName = "team_name"
    case pipelineName = "pipeline_name"
    case nextBuild = "next_build"
    case finishedBuild = "finished_build"
    case transitionBuild = "transition_build"
  }
}
