import Foundation

extension URLSession: HTTPSession {
  public func synchronousDataTask(with: URL) -> (Data?, URLResponse?, Error?) {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    let semaphore = DispatchSemaphore(value: 0)

    _ = dataTask(with: with) {
      data = $0
      response = $1
      error = $2

      semaphore.signal()
      }.resume()

    _ = semaphore.wait(timeout: .distantFuture)

    return (data, response, error)
  }
}
