import Foundation

public protocol HTTPSession {
  func synchronousDataTask(with: URL) -> (Data?, URLResponse?, Error?)
}

public class Target {
  let session: HTTPSession
  public let api: String
  public let team: String

  public init(session: HTTPSession, api: String, team: String) {
    self.session = session
    self.api = api
    self.team = team
  }
}

// MARK: - HTTPClient
extension Target: HTTPClient {
  public func get(_ path: String) -> (HTTPResponse, Error?) {
    let encodedPath = (path as NSString).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
    let builtURL = "\(api)/api/v1/teams/\(team)\(encodedPath)"

    guard let url = URL(string: builtURL) else {
      let error = TargetError("failed to build url: \"\(builtURL)")
      return (HTTPResponse(), error)
    }

    let (d, r, error) = session.synchronousDataTask(with: url)
    if let error = error {
      return (HTTPResponse(), error)
    }

    guard let data = d,
      let response = r as! HTTPURLResponse?
      else { return (HTTPResponse(), TargetError("failed to parse response")) }

    return (HTTPResponse(statusCode: response.statusCode, body: data), nil)
  }
}

// MARK: - TargetError
public struct TargetError: Error {
  public let reason: String

  public init(_ reason: String!) {
    self.reason = reason
  }
}
