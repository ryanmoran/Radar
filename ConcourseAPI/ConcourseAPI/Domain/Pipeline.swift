import Foundation

public struct Pipeline: Decodable {
  public let id: Int
  public let name: String
  public let groups: [Group]?

  public struct Group: Decodable {
    public let name: String
    public let jobs: [String]
  }
}
