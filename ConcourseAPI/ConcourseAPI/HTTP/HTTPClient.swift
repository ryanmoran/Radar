import Foundation

public protocol HTTPClient {
  func get(_ path: String) -> (HTTPResponse, Error?)
}

// MARK: - HTTPResponse
public struct HTTPResponse {
  public let statusCode: Int
  public let body: Data

  public init() {
    statusCode = 0
    body = Data()
  }

  public init(statusCode: Int, body: Data) {
    self.statusCode = statusCode
    self.body = body
  }
}
