import Quick
import Nimble
import ConcourseAPI

class PipelinesServiceSpec: QuickSpec {
  override func spec() {
    var target: FakeTarget!
    var pipelinesService: PipelinesService!

    beforeEach {
      target = FakeTarget()
      pipelinesService = PipelinesService()
    }

    afterEach {
      pipelinesService = nil
      target = nil
    }

    describe("list") {
      it("returns a list of pipelines") {
        let json = """
          [
            {
              "id": 1,
              "name": "some-pipeline-name"
            },
            {
              "id": 2,
              "name": "other-pipeline-name"
            },
          ]
        """

        target.getCall.returns.response = HTTPResponse(statusCode: 200, body: json.data(using: .utf8)!)

        let (pipelines, error) = pipelinesService.list(target: target)
        expect(error).to(beNil())

        expect(pipelines).to(haveCount(2))
        expect(pipelines).to(containElementSatisfying({ pipeline in
          return pipeline.id == 1 && pipeline.name == "some-pipeline-name"
        }))
        expect(pipelines).to(containElementSatisfying({ pipeline in
          return pipeline.id == 2 && pipeline.name == "other-pipeline-name"
        }))

        expect(target.getCall.receives.path).to(equal("/pipelines"))
      }

      describe("failure cases") {
        context("when the target returns an error") {
          it("returns an error") {
            target.getCall.returns.error = TargetError("failed to list pipelines")

            let (_, error) = pipelinesService.list(target: target)
            expect((error as! TargetError).reason).to(equal("failed to list pipelines"))
          }
        }

        context("when the response contains invalid JSON") {
          it("returns an error") {
            target.getCall.returns.response = HTTPResponse(statusCode: 200, body: "%%%".data(using: .utf8)!)

            let (_, error) = pipelinesService.list(target: target)
            expect(error?.localizedDescription).to(equal("The data couldn’t be read because it isn’t in the correct format."))
          }
        }
      }
    }
  }
}
