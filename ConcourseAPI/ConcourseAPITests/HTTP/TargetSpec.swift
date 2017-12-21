import Quick
import Nimble
import ConcourseAPI

class TargetSpec: QuickSpec {
  override func spec() {
    var target: Target!
    var session: FakeHTTPSession!

    beforeEach {
      let urlResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: "1.0", headerFields: nil)!

      session = FakeHTTPSession()
      session.synchronousDataTaskCall.returns.data = "some-data".data(using: .utf8)
      session.synchronousDataTaskCall.returns.urlResponse = urlResponse

      target = Target(session: session, api: "some-api", team: "some-team")
    }

    afterEach {
      target = nil
      session = nil
    }

    describe("get") {
      it("makes requests to the api rooted under a team") {
        let (response, error) = target.get("/some-path")
        expect(error).to(beNil())

        let body = "some-data".data(using: .utf8)!
        expect(response.statusCode).to(equal(200))
        expect(response.body).to(equal(body))

        expect(session.synchronousDataTaskCall.receives.with).to(equal(URL(string:"some-api/api/v1/teams/some-team/some-path")))
      }
    }
  }
}
